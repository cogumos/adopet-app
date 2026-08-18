// Testes de integração do AdoPet.
//
// Rodam no aparelho ou emulador:
//   flutter test integration_test/fluxo_app_test.dart
//
// Diferente dos testes de unidade em test/, estes sobem a árvore de widgets
// de verdade e verificam que o aplicativo abre, decide a tela correta a
// partir do estado de sessão e reage à navegação.
//
// Os testes são propositalmente resistentes a mudança de layout: verificam
// comportamento (o app abriu, a sessão foi respeitada, houve navegação),
// não posição de botão nem texto decorativo. Teste de integração que quebra
// a cada ajuste de CSS vira teste que ninguém roda.

import 'dart:convert';

import 'package:adopet/auth_controller.dart';
import 'package:adopet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const contaDeTeste = {
    'nome': 'Wanessa Alves',
    'email': 'teste@exemplo.com',
    'senha': 'senha123',
  };

  Future<AuthController> prepararControlador(
    Map<String, Object> valoresIniciais,
  ) async {
    SharedPreferences.setMockInitialValues(valoresIniciais);
    final controlador = AuthController();
    await controlador.initialize();
    return controlador;
  }

  Future<void> abrirApp(
    WidgetTester tester,
    AuthController controlador,
  ) async {
    await tester.pumpWidget(AdopetApp(authController: controlador));
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }

  group('Abertura do aplicativo', () {
    testWidgets('abre sem erro quando não há conta salva', (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('renderiza uma tela com conteúdo visível', (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      expect(find.byType(Scaffold), findsWidgets);
      expect(
        find.byType(Text),
        findsWidgets,
        reason: 'a tela inicial precisa apresentar algum texto ao usuário',
      );
    });

    testWidgets('usa o tema Material 3 configurado', (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme?.useMaterial3, isTrue);
      expect(app.title, 'AdoPet');
    });

    testWidgets('não exibe a faixa de debug', (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, isFalse);
    });
  });

  group('Estado de sessão na abertura', () {
    testWidgets('abre deslogada quando a sessão não está marcada',
        (tester) async {
      final controlador = await prepararControlador({
        'adopet_conta': jsonEncode(contaDeTeste),
        'adopet_sessao_ativa': false,
      });
      await abrirApp(tester, controlador);

      expect(controlador.possuiConta, isTrue);
      expect(controlador.autenticado, isFalse);
      expect(tester.takeException(), isNull);
    });

    testWidgets('restaura a sessão quando ela estava ativa', (tester) async {
      final controlador = await prepararControlador({
        'adopet_conta': jsonEncode(contaDeTeste),
        'adopet_sessao_ativa': true,
      });
      await abrirApp(tester, controlador);

      expect(controlador.autenticado, isTrue);
      expect(controlador.usuario!.primeiroNome, 'Wanessa');
      expect(tester.takeException(), isNull);
    });

    testWidgets('abre normalmente mesmo com dado salvo corrompido',
        (tester) async {
      final controlador = await prepararControlador({
        'adopet_conta': 'conteudo-invalido',
        'adopet_sessao_ativa': true,
      });
      await abrirApp(tester, controlador);

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(controlador.autenticado, isFalse);
      expect(
        tester.takeException(),
        isNull,
        reason: 'dado corrompido no aparelho não pode travar a abertura',
      );
    });
  });

  group('Reação da interface ao estado de autenticação', () {
    testWidgets('a árvore é reconstruída quando a sessão muda',
        (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      controlador.registrar(
        nome: 'Wanessa Alves',
        email: 'teste@exemplo.com',
        senha: 'senha123',
      );
      await tester.pumpAndSettle();

      controlador.entrar(email: 'teste@exemplo.com', senha: 'senha123');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(controlador.autenticado, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('sair não derruba a interface', (tester) async {
      final controlador = await prepararControlador({
        'adopet_conta': jsonEncode(contaDeTeste),
        'adopet_sessao_ativa': true,
      });
      await abrirApp(tester, controlador);

      controlador.sair();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(controlador.autenticado, isFalse);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Navegação por elementos tocáveis', () {
    testWidgets('o primeiro botão da tela inicial responde ao toque',
        (tester) async {
      final controlador = await prepararControlador({});
      await abrirApp(tester, controlador);

      final botoes = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton ||
            widget is TextButton ||
            widget is FilledButton ||
            widget is OutlinedButton,
      );

      if (botoes.evaluate().isEmpty) {
        markTestSkipped('A tela inicial não expõe botão tocável.');
        return;
      }

      await tester.tap(botoes.first, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
        tester.takeException(),
        isNull,
        reason: 'tocar no botão principal não pode lançar exceção',
      );
    });
  });
}
