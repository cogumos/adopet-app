import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inicializado = false;

  Future<void> initialize() async {
    if (_inicializado) {
      return;
    }

    const android = AndroidInitializationSettings('app_icon');
    const configuracoes = InitializationSettings(android: android);

    await _plugin.initialize(settings: configuracoes);
    _inicializado = true;
  }

  Future<void> mostrarMensagemPersonalizada({
    required String titulo,
    required String corpo,
  }) async {
    await initialize();

    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final habilitado = await android?.areNotificationsEnabled() ?? false;
      if (!habilitado) {
        final concedido = await android?.requestNotificationsPermission();
        if (!(concedido ?? false)) {
          return;
        }
      }
    }

    const detalhesAndroid = AndroidNotificationDetails(
      'adopet_conta',
      'Conta AdoPet',
      channelDescription: 'Notificações sobre cadastro e login no app',
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
      ticker: 'AdoPet',
      category: AndroidNotificationCategory.message,
    );

    const detalhes = NotificationDetails(android: detalhesAndroid);

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: titulo,
      body: corpo,
      notificationDetails: detalhes,
    );
  }
}
