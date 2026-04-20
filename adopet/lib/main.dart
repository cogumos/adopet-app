import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_controller.dart';
import 'home_page.dart';
import 'notification_service.dart';

const corPrimaria = Color(0xFFFF8F2B);
const corPrimariaEscura = Color(0xFFF17B11);
const corTextoForte = Color(0xFF1E293B);
const corTextoSuave = Color(0xFF64748B);
const corFundoClaro = Color(0xFFFFF5EC);
const corFundoBase = Color(0xFFFFFFFF);
const corFundoApp = Color(0xFFF8FAFC);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = AuthController();
  await authController.initialize();
  await NotificationService.instance.initialize();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    authController.contaRegistrada?.telaCheiaAtiva ?? true
        ? SystemUiMode.immersiveSticky
        : SystemUiMode.edgeToEdge,
  );
  runApp(AdopetApp(authController: authController));
}

class AdopetApp extends StatelessWidget {
  final AuthController authController;

  const AdopetApp({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return AppAuthScope(
      controller: authController,
      child: MaterialApp(
        title: 'AdoPet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: corFundoBase,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: corPrimaria,
            onPrimary: Colors.white,
            secondary: corPrimariaEscura,
            onSecondary: Colors.white,
            error: Color(0xFFB3261E),
            onError: Colors.white,
            surface: corFundoBase,
            onSurface: corTextoForte,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: corTextoForte,
              letterSpacing: -1.2,
            ),
            headlineMedium: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: corTextoForte,
              letterSpacing: -0.9,
            ),
            headlineSmall: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: corTextoForte,
              letterSpacing: -0.7,
            ),
            titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: corTextoForte,
            ),
            titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: corTextoForte,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              height: 1.45,
              color: corTextoSuave,
            ),
            bodyMedium: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: corTextoSuave,
            ),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
