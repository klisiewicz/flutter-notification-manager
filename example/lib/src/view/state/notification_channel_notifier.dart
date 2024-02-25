import 'dart:async';

import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationChannelNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<NotificationChannel>, String> {
  NotificationManager get _notificationManager =>
      ref.read(notificationManagerProvider);

  @override
  FutureOr<List<NotificationChannel>> build(String arg) async {
    final channels = await _notificationManager.getNotificationChannels();
    return channels.where((ch) => ch.groupId == arg).toList();
  }

  Future<void> create({
    required String id,
    required String name,
    required String importance,
    bool showBubble = false,
    bool showBadge = false,
    bool enableLights = false,
    bool enableVibrations = false,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final channel = NotificationChannel(
        id: id,
        name: name,
        importance: Importance.values.byName(importance),
        groupId: arg,
        showBubble: showBubble,
        showBadge: showBadge,
        enableLights: enableLights,
        enableVibrations: enableVibrations,
      );
      await _notificationManager.createNotificationChannel(channel);
      return await build(arg);
    });
  }

  Future<void> delete({
    required String id,
  }) async {
    state = await AsyncValue.guard(() async {
      await _notificationManager.deleteNotificationChannel(id);
      return await build(arg);
    });
  }
}
