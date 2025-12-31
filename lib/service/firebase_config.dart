import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../src/store/utils/app_constant.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // iOS permission
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    // Token
    final token = await _messaging.getToken();
    debugPrint('📲 FCM Token: $token');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 Foreground message: ${message.notification?.title}');
    });

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🚀 Opened from notification');
    });
  }

  static Future<void> updateFcmToken() async {
    try {
      final data = {
        'fcm_token': await _messaging.getToken(),
        // us platform to determine the device type
        'device_type': defaultTargetPlatform == TargetPlatform.iOS
            ? 'ios'
            : 'android',
      };

      final uri = Uri.parse('$PRO_API_BASE_ROUTE/users/fcm-token');
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      debugPrint('❌ Error syncing FCM token: $e');
    }
  }

  //   define a getter to return the firebase token
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
