import 'dart:async';

import 'package:flutter_notification_manager/flutter_notification_manager.dart';
import 'package:flutter_notification_manager_example/src/provider/notification_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationGroupNotifier
    extends AutoDisposeAsyncNotifier<List<NotificationChannelGroup>> {
  NotificationManager get _notificationManager =>
      ref.read(notificationManagerProvider);

  @override
  FutureOr<List<NotificationChannelGroup>> build() async {
    return _notificationManager.getNotificationChannelGroups();
  }

  Future<void> create({
    required String id,
    required String name,
    String? description,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final group = NotificationChannelGroup(
        id: id,
        name: name,
        description: description,
      );
      await _notificationManager.createNotificationChannelGroup(group);
      return _notificationManager.getNotificationChannelGroups();
    });
  }

  Future<void> delete({
    required String id,
  }) async {
    state = await AsyncValue.guard(() async {
      await _notificationManager.deleteNotificationChannelGroup(id);
      return _notificationManager.getNotificationChannelGroups();
    });
  }
}
