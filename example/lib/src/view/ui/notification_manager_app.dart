import 'package:flutter/material.dart';
import 'package:flutter_notification_manager_example/src/view/nav/app_router.dart';
import 'package:flutter_notification_manager_example/src/view/theme/color_schemes.dart';

class NotificationManagerApp extends StatelessWidget {
  const NotificationManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      routerConfig: router,
    );
  }
}
