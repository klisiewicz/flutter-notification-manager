import 'package:flutter_notification_manager/src/notification_channel.dart';
import 'package:flutter_notification_manager/src/notification_channel_group.dart';
import 'package:flutter_notification_manager/src/notification_manager_platform_interface.dart';
import 'package:meta/meta.dart';

@immutable
final class NotificationManager {
  const NotificationManager();

  /// Creates a notification channel that notifications can be posted to.
  /// This can also be used to restore a deleted channel and to update
  /// an existing channel's name, description, group, and/or importance.
  Future<void> createNotificationChannel(NotificationChannel channel) {
    return NotificationManagerPlatform.instance.createNotificationChannel(
      channel,
    );
  }

  /// Creates multiple notification channels that different notifications
  /// can be posted to.
  Future<void> createNotificationChannels(
    List<NotificationChannel> channels,
  ) {
    return NotificationManagerPlatform.instance.createNotificationChannels(
      channels,
    );
  }

  /// Creates a group container for [NotificationChannel] objects.
  /// This can be used to rename an existing group.
  Future<void> createNotificationChannelGroup(
    NotificationChannelGroup group,
  ) {
    return NotificationManagerPlatform.instance.createNotificationChannelGroup(
      group,
    );
  }

  /// Creates multiple notification channel groups.
  Future<void> createNotificationChannelGroups(
    List<NotificationChannelGroup> groups,
  ) {
    return NotificationManagerPlatform.instance.createNotificationChannelGroups(
      groups,
    );
  }

  /// Deletes the given notification channel.
  /// If you create a new channel with this same id, the deleted channel will
  /// be un-deleted with all of the same settings it had before it was deleted.
  Future<void> deleteNotificationChannel(String channelId) {
    return NotificationManagerPlatform.instance.deleteNotificationChannel(
      channelId,
    );
  }

  /// Deletes the given notification channel group, and all notification
  /// channels that belong to it.
  Future<void> deleteNotificationChannelGroup(String groupId) {
    return NotificationManagerPlatform.instance.deleteNotificationChannelGroup(
      groupId,
    );
  }

  /// Returns the notification channel settings for a given channel id.
  Future<NotificationChannel?> getNotificationChannel(
    String channelId,
  ) {
    return NotificationManagerPlatform.instance.getNotificationChannel(
      channelId,
    );
  }

  /// Returns all notification channels belonging to the calling package.
  Future<List<NotificationChannel>> getNotificationChannels() async {
    return NotificationManagerPlatform.instance.getNotificationChannels();
  }

  /// Returns the notification channel group settings for a given channel group id.
  /// The channel group must belong to your package, or null will be returned.
  /// Requires Android P (API 28)
  Future<NotificationChannelGroup?> getNotificationChannelGroup(
    String groupId,
  ) async {
    return NotificationManagerPlatform.instance.getNotificationChannelGroup(
      groupId,
    );
  }

  /// Returns all notification channel groups belonging to the calling app.
  Future<List<NotificationChannelGroup>> getNotificationChannelGroups() async {
    return NotificationManagerPlatform.instance.getNotificationChannelGroups();
  }
}
