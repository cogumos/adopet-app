// Testes de unidade do AuthController.
//
// Rodam sem emulador e sem aparelho: `flutter test`.
// SharedPreferences é substituído por um mock em memória, então nenhum
// teste toca dado real do aparelho.
//
// O foco são as regras que decidem se alguém entra ou não no aplicativo:
// validação de cadastro, conferência de credenciais, sessão e persistência.

import 'dart:convert';

import 'package:adopet/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthController controlador;

  Future<AuthController> criarControlador([
    Map<String, Object> valoresIniciais = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(valoresIniciais);
    final novo = AuthController();
    await novo.initialize();
    return novo;
  }

  setUp(() async {
    controlador = await criarControlador();
  });

  group('Estado inicial', () {
    test('começa sem conta e sem sessão', () {
      expect(controlador.possuiConta, isFalse);
      expect(controlador.autenticado, isFalse);
      expect(controlador.contaRegistrada, isNull);
      expect(controlador.usuario, isNull);
    });
  });

  group('Cadastro — validações', () {
    test('recusa nome vazio', () {
      final resultado = controlador.registrar(
        nome: '   ',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'Digite seu nome para continuar.');
      expect(controlador.possuiConta, isFalse);
    });

    test('recusa e-mail sem arroba', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa',
        email: 'semarroba.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'Digite um e-mail válido.');
    });

    test('recusa e-mail sem domínio', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa',
        email: 'wanessa@',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'Digite um e-mail válido.');
    });

    test('recusa e-mail com espaço no meio', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa',
        email: 'wa nessa@exemplo.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
    });

    test('recusa senha com menos de 6 caracteres', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: '12345',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'A senha precisa ter pelo menos 6 caracteres.');
    });

    test('recusa senha que só tem espaços', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: '        ',
      );

      expect(resultado.sucesso, isFalse);
    });

    test('aceita cadastro válido no limite mínimo de senha', () {
      final resultado = controlador.registrar(
        nome: 'Wanessa Alves',
        email: 'teste@exemplo.com',
        senha: '123456',
      );

      expect(resultado.sucesso, isTrue);
      expect(controlador.possuiConta, isTrue);
    });
  });

  group('Cadastro — normalização', () {
    setUp(() {
      controlador.registrar(
        nome: '  Wanessa Alves  ',
        email: '  TESTE@Exemplo.COM  ',
        senha: '  senha123  ',
      );
    });

    test('remove espaços em volta do nome', () {
      expect(controlador.contaRegistrada!.nome, 'Wanessa Alves');
    });

    test('converte o e-mail para minúsculas', () {
      expect(controlador.contaRegistrada!.email, 'teste@exemplo.com');
    });

    test('remove espaços em volta da senha', () {
      expect(controlador.contaRegistrada!.senha, 'senha123');
    });

    test('cadastro não autentica automaticamente', () {
      expect(controlador.autenticado, isFalse,
          reason: 'o fluxo pede login explícito depois do cadastro');
    });
  });

  group('primeiroNome', () {
    test('devolve apenas o primeiro nome', () {
      controlador.registrar(
        nome: 'Wanessa Alves Silva',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(controlador.contaRegistrada!.primeiroNome, 'Wanessa');
    });

    test('lida com espaços múltiplos entre nomes', () {
      const conta = ContaRegistrada(
        nome: 'Wanessa    Alves',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(conta.primeiroNome, 'Wanessa');
    });

    test('tem texto de reserva quando o nome está vazio', () {
      const conta = ContaRegistrada(
        nome: '',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(conta.primeiroNome, 'Humano');
    });
  });

  group('Login', () {
    setUp(() {
      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );
    });

    test('recusa senha errada', () {
      final resultado = controlador.entrar(
        email: 'teste@exemplo.com',
        senha: 'senhaErrada',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'Email ou senha inválidos.');
      expect(controlador.autenticado, isFalse);
    });

    test('recusa e-mail que não é o cadastrado', () {
      final resultado = controlador.entrar(
        email: 'outro@exemplo.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
      expect(controlador.autenticado, isFalse);
    });

    test('aceita credenciais corretas', () {
      final resultado = controlador.entrar(
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isTrue);
      expect(controlador.autenticado, isTrue);
      expect(controlador.usuario!.email, 'teste@exemplo.com');
    });

    test('aceita e-mail digitado em maiúsculas', () {
      final resultado = controlador.entrar(
        email: 'TESTE@EXEMPLO.COM',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isTrue);
    });

    test('a senha continua sensível a maiúsculas', () {
      final resultado = controlador.entrar(
        email: 'teste@exemplo.com',
        senha: 'SENHA123',
      );

      expect(resultado.sucesso, isFalse,
          reason: 'senha maiúscula não pode ser tratada como igual');
    });
  });

  group('Login sem conta cadastrada', () {
    test('informa que não há conta no aparelho', () {
      final resultado = controlador.entrar(
        email: 'qualquer@exemplo.com',
        senha: 'senha123',
      );

      expect(resultado.sucesso, isFalse);
      expect(resultado.mensagem, 'Nenhuma conta encontrada neste aparelho.');
    });
  });

  group('Sair', () {
    test('encerra a sessão mas preserva a conta', () {
      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );
      controlador.entrar(email: 'teste@exemplo.com', senha: 'senha123');

      controlador.sair();

      expect(controlador.autenticado, isFalse);
      expect(controlador.possuiConta, isTrue,
          reason: 'sair não pode apagar a conta do aparelho');
    });
  });

  group('Atualizar nome', () {
    test('recusa nome vazio', () {
      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(controlador.atualizarNome('   '), isFalse);
      expect(controlador.contaRegistrada!.nome, 'Wanessa');
    });

    test('recusa alteração sem conta cadastrada', () {
      expect(controlador.atualizarNome('Novo Nome'), isFalse);
    });

    test('aplica o novo nome também na sessão ativa', () {
      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );
      controlador.entrar(email: 'teste@exemplo.com', senha: 'senha123');

      expect(controlador.atualizarNome('  Wanessa Alves  '), isTrue);
      expect(controlador.contaRegistrada!.nome, 'Wanessa Alves');
      expect(controlador.usuario!.nome, 'Wanessa Alves');
    });
  });

  group('Persistência entre aberturas do aplicativo', () {
    test('a conta sobrevive ao reinício', () async {
      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );
      await Future<void>.delayed(Duration.zero);

      final preferences = await SharedPreferences.getInstance();
      final contaSalva = preferences.getString('adopet_conta');
      expect(contaSalva, isNotNull);

      final reaberto = await criarControlador({
        'adopet_conta': contaSalva!,
        'adopet_sessao_ativa': false,
      });

      expect(reaberto.possuiConta, isTrue);
      expect(reaberto.contaRegistrada!.email, 'teste@exemplo.com');
      expect(reaberto.autenticado, isFalse);
    });

    test('a sessão ativa é restaurada quando marcada', () async {
      const conta = {
        'nome': 'Wanessa',
        'email': 'teste@exemplo.com',
        'senha': 'senha123',
      };

      final reaberto = await criarControlador({
        'adopet_conta': jsonEncode(conta),
        'adopet_sessao_ativa': true,
      });

      expect(reaberto.autenticado, isTrue);
    });

    test('dado corrompido não derruba o aplicativo', () async {
      final reaberto = await criarControlador({
        'adopet_conta': 'isto-nao-e-json',
        'adopet_sessao_ativa': true,
      });

      expect(reaberto.possuiConta, isFalse);
      expect(reaberto.autenticado, isFalse);
    });

    test('JSON válido mas fora do formato esperado é ignorado', () async {
      final reaberto = await criarControlador({
        'adopet_conta': '[1, 2, 3]',
        'adopet_sessao_ativa': true,
      });

      expect(reaberto.possuiConta, isFalse);
    });
  });

  group('Notificação de mudanças', () {
    test('avisa os ouvintes ao cadastrar', () {
      var avisos = 0;
      controlador.addListener(() => avisos++);

      controlador.registrar(
        nome: 'Wanessa',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );

      expect(avisos, greaterThan(0));
    });

    test('não avisa quando sair é chamado sem sessão', () {
      var avisos = 0;
      controlador.addListener(() => avisos++);

      controlador.sair();

      expect(avisos, 0);
    });
  });
}
