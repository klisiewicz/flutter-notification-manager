import 'package:flutter_notification_manager/src/notification_channel.dart';
import 'package:flutter_notification_manager/src/notification_channel_group.dart';
import 'package:flutter_notification_manager/src/notification_manager_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class NotificationManagerPlatform extends PlatformInterface {
  /// Constructs a FlutterNotificationManagerPlatform.
  NotificationManagerPlatform() : super(token: _token);

  static final Object _token = Object();

  static NotificationManagerPlatform _instance =
      MethodChannelNotificationManager();

  /// The default instance of [NotificationManagerPlatform] to use.
  ///
  /// Defaults to [MethodChannelNotificationManager].
  static NotificationManagerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NotificationManagerPlatform] when
  /// they register themselves.
  static set instance(NotificationManagerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> createNotificationChannel(NotificationChannel channel);

  Future<void> createNotificationChannelGroup(NotificationChannelGroup group);

  Future<void> createNotificationChannelGroups(
    List<NotificationChannelGroup> groups,
  );

  Future<void> createNotificationChannels(List<NotificationChannel> channels);

  Future<void> deleteNotificationChannel(String channelId);

  Future<void> deleteNotificationChannelGroup(String groupId);

  Future<NotificationChannel?> getNotificationChannel(String channelId);

  Future<NotificationChannelGroup?> getNotificationChannelGroup(String groupId);

  Future<List<NotificationChannelGroup>> getNotificationChannelGroups();

  Future<List<NotificationChannel>> getNotificationChannels();
}
