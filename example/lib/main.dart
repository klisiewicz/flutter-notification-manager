import 'package:flutter/material.dart';
import 'package:flutter_notification_manager_example/src/view/ui/notification_manager_app.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NotificationManagerApp(),
    ),
  );
}
