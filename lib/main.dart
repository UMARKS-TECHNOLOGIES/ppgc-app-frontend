import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppgc_pro/service/firebase_config.dart';
import 'package:ppgc_pro/service/local_notification_service.dart';
import 'package:ppgc_pro/src/routes/indexRoute.dart';
import 'package:ppgc_pro/src/utils/themeData.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FCMService.init(); // SAFE here

  await LocalNotificationService.init();
  await LocalNotificationService.requestPermission();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Prince Properties',
      theme: customTheme,
    );
  }
}
