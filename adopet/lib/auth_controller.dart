import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContaRegistrada {
  final String nome;
  final String email;
  final String senha;
  final String? fotoPerfilPath;
  final bool notificacoesAtivas;
  final bool localizacaoAproximadaAtiva;
  final bool telaCheiaAtiva;

  const ContaRegistrada({
    required this.nome,
    required this.email,
    required this.senha,
    this.fotoPerfilPath,
    this.notificacoesAtivas = true,
    this.localizacaoAproximadaAtiva = true,
    this.telaCheiaAtiva = true,
  });

  String get primeiroNome {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) {
      return 'Humano';
    }
    return partes.first;
  }

  ContaRegistrada copyWith({
    String? nome,
    String? email,
    String? senha,
    String? fotoPerfilPath,
    bool? notificacoesAtivas,
    bool? localizacaoAproximadaAtiva,
    bool? telaCheiaAtiva,
  }) {
    return ContaRegistrada(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      fotoPerfilPath: fotoPerfilPath ?? this.fotoPerfilPath,
      notificacoesAtivas: notificacoesAtivas ?? this.notificacoesAtivas,
      localizacaoAproximadaAtiva:
          localizacaoAproximadaAtiva ?? this.localizacaoAproximadaAtiva,
      telaCheiaAtiva: telaCheiaAtiva ?? this.telaCheiaAtiva,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
      'fotoPerfilPath': fotoPerfilPath,
      'notificacoesAtivas': notificacoesAtivas,
      'localizacaoAproximadaAtiva': localizacaoAproximadaAtiva,
      'telaCheiaAtiva': telaCheiaAtiva,
    };
  }

  factory ContaRegistrada.fromMap(Map<String, dynamic> map) {
    return ContaRegistrada(
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      senha: map['senha'] as String? ?? '',
      fotoPerfilPath: map['fotoPerfilPath'] as String?,
      notificacoesAtivas: map['notificacoesAtivas'] as bool? ?? true,
      localizacaoAproximadaAtiva:
          map['localizacaoAproximadaAtiva'] as bool? ?? true,
      telaCheiaAtiva: map['telaCheiaAtiva'] as bool? ?? true,
    );
  }
}

class ResultadoAutenticacao {
  final bool sucesso;
  final String mensagem;
  final String? tituloNotificacao;
  final String? corpoNotificacao;

  const ResultadoAutenticacao({
    required this.sucesso,
    required this.mensagem,
    this.tituloNotificacao,
    this.corpoNotificacao,
  });
}

class AuthController extends ChangeNotifier {
  static const _chaveConta = 'adopet_conta';
  static const _chaveSessaoAtiva = 'adopet_sessao_ativa';

  SharedPreferences? _preferences;
  ContaRegistrada? _contaRegistrada;
  ContaRegistrada? _usuario;

  ContaRegistrada? get contaRegistrada => _contaRegistrada;
  ContaRegistrada? get usuario => _usuario;
  bool get autenticado => _usuario != null;
  bool get possuiConta => _contaRegistrada != null;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();

    final contaSalva = _preferences?.getString(_chaveConta);
    final sessaoAtiva = _preferences?.getBool(_chaveSessaoAtiva) ?? false;

    if (contaSalva == null || contaSalva.isEmpty) {
      return;
    }

    try {
      final dados = jsonDecode(contaSalva);
      if (dados is! Map<String, dynamic>) {
        return;
      }

      _contaRegistrada = ContaRegistrada.fromMap(dados);
      if (sessaoAtiva) {
        _usuario = _contaRegistrada;
      }
    } catch (_) {
      await _limparPersistencia();
      _contaRegistrada = null;
      _usuario = null;
    }
  }

  ResultadoAutenticacao registrar({
    required String nome,
    required String email,
    required String senha,
  }) {
    final nomeLimpo = nome.trim();
    final emailLimpo = email.trim().toLowerCase();
    final senhaLimpa = senha.trim();

    if (nomeLimpo.isEmpty) {
      return const ResultadoAutenticacao(
        sucesso: false,
        mensagem: 'Digite seu nome para continuar.',
      );
    }

    if (!_emailValido(emailLimpo)) {
      return const ResultadoAutenticacao(
        sucesso: false,
        mensagem: 'Digite um e-mail válido.',
      );
    }

    if (senhaLimpa.length < 6) {
      return const ResultadoAutenticacao(
        sucesso: false,
        mensagem: 'A senha precisa ter pelo menos 6 caracteres.',
      );
    }

    _contaRegistrada = ContaRegistrada(
      nome: nomeLimpo,
      email: emailLimpo,
      senha: senhaLimpa,
      fotoPerfilPath: _contaRegistrada?.fotoPerfilPath,
      notificacoesAtivas: _contaRegistrada?.notificacoesAtivas ?? true,
      localizacaoAproximadaAtiva:
          _contaRegistrada?.localizacaoAproximadaAtiva ?? true,
      telaCheiaAtiva: _contaRegistrada?.telaCheiaAtiva ?? true,
    );
    _usuario = null;
    _persistirEstado();
    notifyListeners();

    return _resultadoCadastroSucesso(_contaRegistrada!.primeiroNome);
  }

  ResultadoAutenticacao _resultadoCadastroSucesso(String primeiroNome) {
    return ResultadoAutenticacao(
      sucesso: true,
      mensagem: 'Conta criada. Agora, entre com e-mail e senha.',
      tituloNotificacao: 'Conta criada',
      corpoNotificacao:
          '$primeiroNome, sua conta no AdoPet foi criada com sucesso.',
    );
  }

  ResultadoAutenticacao entrar({required String email, required String senha}) {
    final conta = _contaRegistrada;
    if (conta == null) {
      return const ResultadoAutenticacao(
        sucesso: false,
        mensagem: 'Nenhuma conta encontrada neste aparelho.',
      );
    }

    final emailLimpo = email.trim().toLowerCase();
    final senhaLimpa = senha.trim();

    if (emailLimpo != conta.email || senhaLimpa != conta.senha) {
      return const ResultadoAutenticacao(
        sucesso: false,
        mensagem: 'Email ou senha inválidos.',
      );
    }

    _usuario = conta;
    _persistirEstado();
    notifyListeners();

    return ResultadoAutenticacao(
      sucesso: true,
      mensagem: 'Olá, ${conta.primeiroNome}!',
      tituloNotificacao: 'Login realizado',
      corpoNotificacao:
          'Bem-vindo de volta, ${conta.primeiroNome}. Seu perfil já está ativo no AdoPet.',
    );
  }

  void sair() {
    if (_usuario == null) {
      return;
    }
    _usuario = null;
    _persistirEstado();
    notifyListeners();
  }

  void atualizarFotoPerfil(String caminho) {
    final conta = _contaRegistrada;
    if (conta == null) {
      return;
    }

    _sincronizarConta(conta.copyWith(fotoPerfilPath: caminho));
  }

  bool atualizarNome(String nome) {
    final conta = _contaRegistrada;
    if (conta == null) {
      return false;
    }

    final nomeLimpo = nome.trim();
    if (nomeLimpo.isEmpty) {
      return false;
    }

    _sincronizarConta(conta.copyWith(nome: nomeLimpo));
    return true;
  }

  void atualizarConfiguracoes({
    bool? notificacoesAtivas,
    bool? localizacaoAproximadaAtiva,
    bool? telaCheiaAtiva,
  }) {
    final conta = _contaRegistrada;
    if (conta == null) {
      return;
    }

    _sincronizarConta(
      conta.copyWith(
        notificacoesAtivas: notificacoesAtivas,
        localizacaoAproximadaAtiva: localizacaoAproximadaAtiva,
        telaCheiaAtiva: telaCheiaAtiva,
      ),
    );
  }

  void _sincronizarConta(ContaRegistrada novaConta) {
    _contaRegistrada = novaConta;
    if (_usuario != null) {
      _usuario = novaConta;
    }
    _persistirEstado();
    notifyListeners();
  }

  Future<void> _persistirEstado() async {
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    _preferences = preferences;

    if (_contaRegistrada == null) {
      await _limparPersistencia();
      return;
    }

    await preferences.setString(
      _chaveConta,
      jsonEncode(_contaRegistrada!.toMap()),
    );
    await preferences.setBool(_chaveSessaoAtiva, _usuario != null);
  }

  Future<void> _limparPersistencia() async {
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    _preferences = preferences;
    await preferences.remove(_chaveConta);
    await preferences.remove(_chaveSessaoAtiva);
  }

  bool _emailValido(String email) {
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }
}

class AppAuthScope extends InheritedNotifier<AuthController> {
  const AppAuthScope({
    super.key,
    required AuthController controller,
    required super.child,
  }) : super(notifier: controller);

  static AuthController watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppAuthScope>();
    assert(scope != null, 'AppAuthScope não encontrado no contexto.');
    return scope!.notifier!;
  }

  static AuthController read(BuildContext context) {
    final element = context
        .getElementForInheritedWidgetOfExactType<AppAuthScope>();
    final scope = element?.widget as AppAuthScope?;
    assert(scope != null, 'AppAuthScope não encontrado no contexto.');
    return scope!.notifier!;
  }
}
