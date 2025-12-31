import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // iOS permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Token
    final token = await _messaging.getToken();
    debugPrint('📲 FCM Token: $token');

    // TODO: Send token to backend
    // await ApiService.updateFcmToken(token);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message: ${message.notification?.title}');
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🚀 Opened from notification');
    });
  }
}
