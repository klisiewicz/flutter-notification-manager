import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/view/state/notification_channel_notifier.dart';
import 'package:flutter_notification_manager_example/src/view/state/notification_group_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final notificationManagerProvider =
    Provider.autoDispose<NotificationManager>((ref) {
  return const NotificationManager();
});

final notificationGroupProvider = AsyncNotifierProvider.autoDispose<
    NotificationGroupNotifier, List<NotificationChannelGroup>>(
  NotificationGroupNotifier.new,
);

final notificationChannelProvider = AsyncNotifierProvider.autoDispose
    .family<NotificationChannelNotifier, List<NotificationChannel>, String>(
  NotificationChannelNotifier.new,
);
