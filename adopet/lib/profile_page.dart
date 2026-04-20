import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'auth_controller.dart';
import 'main.dart';
import 'notification_service.dart';
import 'profile_sections_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _abrirFluxoAutenticacao(
    BuildContext context,
    ModoAutenticacao modo,
  ) async {
    final resultado = await Navigator.of(context).push<ResultadoAutenticacao>(
      MaterialPageRoute(
        builder: (context) => _TelaAutenticacaoPage(modoInicial: modo),
      ),
    );

    if (resultado == null || !context.mounted) {
      return;
    }

    final auth = AppAuthScope.read(context);
    final notificacoesAtivas = auth.contaRegistrada?.notificacoesAtivas ?? true;

    if (resultado.sucesso &&
        notificacoesAtivas &&
        resultado.tituloNotificacao != null &&
        resultado.corpoNotificacao != null) {
      await NotificationService.instance.mostrarMensagemPersonalizada(
        titulo: resultado.tituloNotificacao!,
        corpo: resultado.corpoNotificacao!,
      );
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(resultado.mensagem),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _abrirMeusAnimais(
    BuildContext context,
    ContaRegistrada usuario,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MeusAnimaisPage(usuario: usuario),
      ),
    );
  }

  Future<void> _abrirHistorico(
    BuildContext context,
    ContaRegistrada usuario,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoricoAdocaoPage(usuario: usuario),
      ),
    );
  }

  Future<void> _abrirAjuda(
    BuildContext context,
    ContaRegistrada usuario,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AjudaSuportePage(usuario: usuario),
      ),
    );
  }

  Future<void> _abrirConfiguracoes(
    BuildContext context,
    AuthController auth,
  ) async {
    final saiuDaConta = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (pageContext) => ConfiguracoesPage(
          auth: auth,
          onSelecionarFotoPerfil: (contextoDaTela) =>
              _selecionarFotoPerfil(contextoDaTela, auth),
        ),
      ),
    );

    if (saiuDaConta == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Sessão encerrada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  void _sair(BuildContext context, AuthController auth) {
    auth.sair();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Sessão encerrada.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _selecionarFotoPerfil(
    BuildContext context,
    AuthController auth,
  ) async {
    final picker = ImagePicker();

    try {
      final arquivo = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 88,
        maxWidth: 1400,
      );

      if (arquivo == null) {
        return;
      }

      auth.atualizarFotoPerfil(arquivo.path);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Foto de perfil atualizada.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Não foi possível selecionar a foto.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AppAuthScope.watch(context);

    if (!auth.autenticado) {
      return _PerfilDeslogado(
        possuiConta: auth.possuiConta,
        onEntrar: () =>
            _abrirFluxoAutenticacao(context, ModoAutenticacao.entrar),
        onCriarConta: () =>
            _abrirFluxoAutenticacao(context, ModoAutenticacao.criarConta),
      );
    }

    return _PerfilAutenticado(
      usuario: auth.usuario!,
      onSair: () => _sair(context, auth),
      onSelecionarFoto: () => _selecionarFotoPerfil(context, auth),
      onAbrirMeusAnimais: () => _abrirMeusAnimais(context, auth.usuario!),
      onAbrirHistorico: () => _abrirHistorico(context, auth.usuario!),
      onAbrirConfiguracoes: () => _abrirConfiguracoes(context, auth),
      onAbrirAjuda: () => _abrirAjuda(context, auth.usuario!),
    );
  }
}

class _PerfilDeslogado extends StatelessWidget {
  final bool possuiConta;
  final VoidCallback onEntrar;
  final VoidCallback onCriarConta;

  const _PerfilDeslogado({
    required this.possuiConta,
    required this.onEntrar,
    required this.onCriarConta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tamanho = MediaQuery.sizeOf(context);
    final compacto = tamanho.width < 380 || tamanho.height < 760;
    final avatarTamanho = compacto ? 126.0 : 146.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFDFEFE), Color(0xFFF3F6FB)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 160),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  24,
                  compacto ? 24 : 28,
                  24,
                  compacto ? 26 : 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120F172A),
                      blurRadius: 28,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: avatarTamanho,
                      height: avatarTamanho,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: avatarTamanho,
                            height: avatarTamanho,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5FB),
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: compacto ? 62 : 72,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: compacto ? 54 : 58,
                              height: compacto ? 54 : 58,
                              decoration: BoxDecoration(
                                color: corPrimaria,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x24FF8F2B),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: compacto ? 22 : 28),
                    Text(
                      'Seu perfil',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: compacto ? 28 : 31,
                        color: const Color(0xFF24324A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      possuiConta
                          ? 'Entre com seu e-mail e sua senha para acessar favoritos, mensagens e adoções.'
                          : 'Crie sua conta para salvar pets favoritos e conversar com abrigos.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF8A9BB6),
                        fontSize: compacto ? 16 : 17,
                      ),
                    ),
                    SizedBox(height: compacto ? 28 : 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final empilhar = constraints.maxWidth < 330;

                        if (empilhar) {
                          return Column(
                            children: [
                              _BotaoPrimarioPerfil(
                                rotulo: 'Entrar',
                                onTap: onEntrar,
                              ),
                              const SizedBox(height: 12),
                              _BotaoSecundarioPerfil(
                                rotulo: 'Criar conta',
                                onTap: onCriarConta,
                              ),
                            ],
                          );
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: _BotaoPrimarioPerfil(
                                rotulo: 'Entrar',
                                onTap: onEntrar,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _BotaoSecundarioPerfil(
                                rotulo: 'Criar conta',
                                onTap: onCriarConta,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarPerfil extends StatelessWidget {
  final double tamanho;
  final bool compacto;
  final String? fotoPerfilPath;
  final VoidCallback? onTap;

  const _AvatarPerfil({
    required this.tamanho,
    required this.compacto,
    this.fotoPerfilPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final arquivoExiste =
        fotoPerfilPath != null && File(fotoPerfilPath!).existsSync();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: tamanho,
          height: tamanho,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5FB),
            borderRadius: BorderRadius.circular(36),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140F172A),
                blurRadius: 24,
                offset: Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: arquivoExiste
                ? Image.file(
                    File(fotoPerfilPath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person_outline_rounded,
                        size: compacto ? 62 : 72,
                        color: const Color(0xFF94A3B8),
                      );
                    },
                  )
                : Icon(
                    Icons.person_outline_rounded,
                    size: compacto ? 62 : 72,
                    color: const Color(0xFF94A3B8),
                  ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: Container(
                width: compacto ? 54 : 58,
                height: compacto ? 54 : 58,
                decoration: BoxDecoration(
                  color: corPrimaria,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x24FF8F2B),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PerfilAutenticado extends StatelessWidget {
  final ContaRegistrada usuario;
  final VoidCallback onSair;
  final VoidCallback onSelecionarFoto;
  final VoidCallback onAbrirMeusAnimais;
  final VoidCallback onAbrirHistorico;
  final VoidCallback onAbrirConfiguracoes;
  final VoidCallback onAbrirAjuda;

  const _PerfilAutenticado({
    required this.usuario,
    required this.onSair,
    required this.onSelecionarFoto,
    required this.onAbrirMeusAnimais,
    required this.onAbrirHistorico,
    required this.onAbrirConfiguracoes,
    required this.onAbrirAjuda,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tamanho = MediaQuery.sizeOf(context);
    final compacto = tamanho.width < 380 || tamanho.height < 760;
    final avatarTamanho = compacto ? 126.0 : 146.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFDFEFE), Color(0xFFF3F6FB)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      24,
                      compacto ? 22 : 28,
                      24,
                      compacto ? 108 : 120,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(42),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0F0F172A),
                          blurRadius: 26,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: avatarTamanho,
                          height: avatarTamanho,
                          child: _AvatarPerfil(
                            tamanho: avatarTamanho,
                            compacto: compacto,
                            fotoPerfilPath: usuario.fotoPerfilPath,
                            onTap: onSelecionarFoto,
                          ),
                        ),
                        SizedBox(height: compacto ? 22 : 28),
                        Text(
                          'Olá, ${usuario.primeiroNome}!',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: compacto ? 26 : 30,
                            color: const Color(0xFF24324A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          usuario.email,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF8A9BB6),
                            fontSize: compacto ? 16 : 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: compacto ? -54 : -60,
                    child: _ResumoPerfilCard(compacto: compacto),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                20,
                compacto ? 82 : 92,
                20,
                compacto ? 148 : 164,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Geral',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF24324A),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x100F172A),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _ItemMenuPerfil(
                            icone: Icons.pets_rounded,
                            titulo: 'Meus animais',
                            fundoIcone: Color(0xFFFFF4EA),
                            corIcone: corPrimariaEscura,
                            onTap: onAbrirMeusAnimais,
                          ),
                          const _DivisorMenuPerfil(),
                          _ItemMenuPerfil(
                            icone: Icons.history_rounded,
                            titulo: 'Histórico de adoção',
                            fundoIcone: Color(0xFFEEF4FF),
                            corIcone: Color(0xFF3B82F6),
                            onTap: onAbrirHistorico,
                          ),
                          const _DivisorMenuPerfil(),
                          _ItemMenuPerfil(
                            icone: Icons.settings_outlined,
                            titulo: 'Configurações',
                            fundoIcone: Color(0xFFF2F5FA),
                            corIcone: Color(0xFF64748B),
                            onTap: onAbrirConfiguracoes,
                          ),
                          const _DivisorMenuPerfil(),
                          _ItemMenuPerfil(
                            icone: Icons.help_outline_rounded,
                            titulo: 'Ajuda e suporte',
                            fundoIcone: Color(0xFFF6EEFF),
                            corIcone: Color(0xFFA855F7),
                            onTap: onAbrirAjuda,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(26),
                        onTap: onSair,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: compacto ? 54 : 58,
                                height: compacto ? 54 : 58,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.logout_rounded,
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Sair da conta',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: const Color(0xFFEF4444),
                                  fontSize: compacto ? 17 : 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ModoAutenticacao { entrar, criarConta }

class _FluxoAutenticacaoSheet extends StatefulWidget {
  final ModoAutenticacao modoInicial;

  const _FluxoAutenticacaoSheet({required this.modoInicial});

  @override
  State<_FluxoAutenticacaoSheet> createState() =>
      _FluxoAutenticacaoSheetState();
}

class _FluxoAutenticacaoSheetState extends State<_FluxoAutenticacaoSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late int _abaAtual;
  String? _erroLogin;
  String? _erroCadastro;
  String? _mensagemLogin;
  bool _mostrarSenhaLogin = false;
  bool _mostrarSenhaCadastro = false;

  final _loginEmailController = TextEditingController();
  final _loginSenhaController = TextEditingController();
  final _cadastroNomeController = TextEditingController();
  final _cadastroEmailController = TextEditingController();
  final _cadastroSenhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _abaAtual = widget.modoInicial == ModoAutenticacao.entrar ? 0 : 1;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _abaAtual,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginSenhaController.dispose();
    _cadastroNomeController.dispose();
    _cadastroEmailController.dispose();
    _cadastroSenhaController.dispose();
    super.dispose();
  }

  void _selecionarAba(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _abaAtual = index;
      if (index == 0) {
        _erroCadastro = null;
      } else {
        _erroLogin = null;
      }
    });
  }

  void _limparMensagemDaAbaAtual() {
    if (_abaAtual == 0) {
      if (_erroLogin == null && _mensagemLogin == null) {
        return;
      }
      setState(() {
        _erroLogin = null;
        _mensagemLogin = null;
      });
      return;
    }

    if (_erroCadastro == null) {
      return;
    }
    setState(() {
      _erroCadastro = null;
    });
  }

  Future<void> _entrar() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _erroLogin = null;
      _mensagemLogin = null;
    });

    final auth = AppAuthScope.read(context);
    final resultado = auth.entrar(
      email: _loginEmailController.text,
      senha: _loginSenhaController.text,
    );

    if (!resultado.sucesso) {
      setState(() {
        _erroLogin = resultado.mensagem;
      });
      return;
    }

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(resultado);
  }

  Future<void> _criarConta() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _erroCadastro = null;
    });

    final auth = AppAuthScope.read(context);
    final resultado = auth.registrar(
      nome: _cadastroNomeController.text,
      email: _cadastroEmailController.text,
      senha: _cadastroSenhaController.text,
    );

    if (!resultado.sucesso) {
      setState(() {
        _erroCadastro = resultado.mensagem;
      });
      return;
    }

    final notificacoesAtivas = auth.contaRegistrada?.notificacoesAtivas ?? true;
    if (notificacoesAtivas &&
        resultado.tituloNotificacao != null &&
        resultado.corpoNotificacao != null) {
      await NotificationService.instance.mostrarMensagemPersonalizada(
        titulo: resultado.tituloNotificacao!,
        corpo: resultado.corpoNotificacao!,
      );
    }

    _loginEmailController.text = _cadastroEmailController.text.trim();
    _loginSenhaController.clear();
    _cadastroSenhaController.clear();
    _tabController.animateTo(0);

    if (!mounted) {
      return;
    }

    setState(() {
      _abaAtual = 0;
      _mensagemLogin = resultado.mensagem;
      _erroCadastro = null;
    });
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Column(
      key: const ValueKey('login'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entrar na sua conta',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFF24324A),
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Use o e-mail e a senha do seu perfil para acessar favoritos, mensagens e adoções.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF7B8CA6),
          ),
        ),
        const SizedBox(height: 20),
        _CampoAutenticacao(
          controller: _loginEmailController,
          label: 'E-mail',
          hint: 'seuemail@exemplo.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.alternate_email_rounded,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          onChanged: (_) => _limparMensagemDaAbaAtual(),
        ),
        const SizedBox(height: 14),
        _CampoAutenticacao(
          controller: _loginSenhaController,
          label: 'Senha',
          hint: 'Digite sua senha',
          obscureText: !_mostrarSenhaLogin,
          textInputAction: TextInputAction.done,
          prefixIcon: Icons.lock_outline_rounded,
          autofillHints: const [AutofillHints.password],
          onChanged: (_) => _limparMensagemDaAbaAtual(),
          onSubmitted: (_) => _entrar(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _mostrarSenhaLogin = !_mostrarSenhaLogin;
              });
            },
            icon: Icon(
              _mostrarSenhaLogin
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        if (_mensagemLogin != null) ...[
          const SizedBox(height: 14),
          _MensagemAutenticacao(mensagem: _mensagemLogin!, sucesso: true),
        ],
        if (_erroLogin != null) ...[
          const SizedBox(height: 14),
          _MensagemAutenticacao(mensagem: _erroLogin!, sucesso: false),
        ],
        const SizedBox(height: 22),
        _BotaoPrimarioPerfil(rotulo: 'Entrar', onTap: _entrar),
      ],
    );
  }

  Widget _buildCadastroForm(ThemeData theme) {
    return Column(
      key: const ValueKey('cadastro'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Criar nova conta',
          style: theme.textTheme.titleLarge?.copyWith(
            color: const Color(0xFF24324A),
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Preencha seus dados para montar seu perfil e continuar sua jornada de adoção.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: const Color(0xFF7B8CA6),
          ),
        ),
        const SizedBox(height: 20),
        _CampoAutenticacao(
          controller: _cadastroNomeController,
          label: 'Nome',
          hint: 'Como você gosta de ser chamado?',
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          onChanged: (_) => _limparMensagemDaAbaAtual(),
        ),
        const SizedBox(height: 14),
        _CampoAutenticacao(
          controller: _cadastroEmailController,
          label: 'E-mail',
          hint: 'seuemail@exemplo.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.alternate_email_rounded,
          autofillHints: const [AutofillHints.newUsername, AutofillHints.email],
          onChanged: (_) => _limparMensagemDaAbaAtual(),
        ),
        const SizedBox(height: 14),
        _CampoAutenticacao(
          controller: _cadastroSenhaController,
          label: 'Senha',
          hint: 'Mínimo de 6 caracteres',
          obscureText: !_mostrarSenhaCadastro,
          textInputAction: TextInputAction.done,
          prefixIcon: Icons.lock_outline_rounded,
          autofillHints: const [AutofillHints.newPassword],
          onChanged: (_) => _limparMensagemDaAbaAtual(),
          onSubmitted: (_) => _criarConta(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _mostrarSenhaCadastro = !_mostrarSenhaCadastro;
              });
            },
            icon: Icon(
              _mostrarSenhaCadastro
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          ),
        ),
        if (_erroCadastro != null) ...[
          const SizedBox(height: 14),
          _MensagemAutenticacao(mensagem: _erroCadastro!, sucesso: false),
        ],
        const SizedBox(height: 22),
        _BotaoPrimarioPerfil(rotulo: 'Criar conta', onTap: _criarConta),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        26,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acesse seu perfil',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF24324A),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE7ECF4)),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: _selecionarAba,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x120F172A),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              labelColor: const Color(0xFF24324A),
              unselectedLabelColor: const Color(0xFF7B8CA6),
              labelStyle: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: 'Login'),
                Tab(text: 'Criar conta'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _abaAtual == 0
                ? _buildLoginForm(theme)
                : _buildCadastroForm(theme),
          ),
        ],
      ),
    );
  }
}

class _CampoAutenticacao extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final List<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;

  const _CampoAutenticacao({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF94A3B8)),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
    );
  }
}

class _MensagemAutenticacao extends StatelessWidget {
  final String mensagem;
  final bool sucesso;

  const _MensagemAutenticacao({required this.mensagem, required this.sucesso});

  @override
  Widget build(BuildContext context) {
    final corFundo = sucesso
        ? const Color(0xFFEFFCF4)
        : const Color(0xFFFFF1F2);
    final corTexto = sucesso
        ? const Color(0xFF15803D)
        : const Color(0xFFDC2626);
    final icone = sucesso
        ? Icons.check_circle_outline_rounded
        : Icons.error_outline_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icone, color: corTexto, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensagem,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: corTexto,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TelaAutenticacaoPage extends StatelessWidget {
  final ModoAutenticacao modoInicial;

  const _TelaAutenticacaoPage({required this.modoInicial});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFCF8), Color(0xFFF1F5FB)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF24324A),
                      ),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Entrar ou criar conta',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: const Color(0xFF24324A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(34),
                            bottom: Radius.circular(34),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x140F172A),
                              blurRadius: 28,
                              offset: Offset(0, 18),
                            ),
                          ],
                        ),
                        child: _FluxoAutenticacaoSheet(
                          modoInicial: modoInicial,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotaoPrimarioPerfil extends StatelessWidget {
  final String rotulo;
  final VoidCallback onTap;

  const _BotaoPrimarioPerfil({required this.rotulo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFFF7A13),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          rotulo,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}

class _BotaoSecundarioPerfil extends StatelessWidget {
  final String rotulo;
  final VoidCallback onTap;

  const _BotaoSecundarioPerfil({required this.rotulo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          side: const BorderSide(color: Color(0xFFE7ECF4), width: 1.5),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF4A5971),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          rotulo,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF4A5971),
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class _ResumoPerfilCard extends StatelessWidget {
  final bool compacto;

  const _ResumoPerfilCard({required this.compacto});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compacto ? 18 : 22,
        vertical: compacto ? 18 : 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _InfoResumoPerfil(
              valor: '4',
              rotulo: 'Favoritos',
              theme: theme,
            ),
          ),
          _DivisorResumoPerfil(compacto: compacto),
          Expanded(
            child: _InfoResumoPerfil(
              valor: '3',
              rotulo: 'Mensagens',
              theme: theme,
            ),
          ),
          _DivisorResumoPerfil(compacto: compacto),
          Expanded(
            child: _InfoResumoPerfil(
              valor: '0',
              rotulo: 'Adoções',
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoResumoPerfil extends StatelessWidget {
  final String valor;
  final String rotulo;
  final ThemeData theme;

  const _InfoResumoPerfil({
    required this.valor,
    required this.rotulo,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          valor,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: const Color(0xFF24324A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          rotulo.toUpperCase(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF8A9BB6),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _DivisorResumoPerfil extends StatelessWidget {
  final bool compacto;

  const _DivisorResumoPerfil({required this.compacto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: compacto ? 48 : 54,
      color: const Color(0xFFEAF0F7),
    );
  }
}

class _ItemMenuPerfil extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final Color fundoIcone;
  final Color corIcone;
  final VoidCallback onTap;

  const _ItemMenuPerfil({
    required this.icone,
    required this.titulo,
    required this.fundoIcone,
    required this.corIcone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: fundoIcone,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icone, color: corIcone, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  titulo,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF24324A),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFC4CFDE),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DivisorMenuPerfil extends StatelessWidget {
  const _DivisorMenuPerfil();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F5F9),
      indent: 18,
      endIndent: 18,
    );
  }
}
