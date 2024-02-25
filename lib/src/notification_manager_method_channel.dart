import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_manager/src/notification_channel.dart';
import 'package:flutter_notification_manager/src/notification_channel_group.dart';
import 'package:flutter_notification_manager/src/notification_manager_platform_interface.dart';

/// An implementation of [NotificationManagerPlatform] that uses method channels.
class MethodChannelNotificationManager extends NotificationManagerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_notification_manager');

  @override
  Future<void> createNotificationChannel(NotificationChannel channel) async {
    await methodChannel.invokeMethod<Map>('createNotificationChannel', {
      'channel': channel.toJson(),
    });
  }

  @override
  Future<void> createNotificationChannels(
    List<NotificationChannel> channels,
  ) async {
    await methodChannel.invokeMethod('createNotificationChannels', {
      'channels': channels.map((channel) => channel.toJson()).toList(),
    });
  }

  @override
  Future<void> createNotificationChannelGroup(
    NotificationChannelGroup group,
  ) async {
    await methodChannel.invokeMethod<Map>('createNotificationChannelGroup', {
      'group': group.toJson(),
    });
  }

  @override
  Future<void> createNotificationChannelGroups(
    List<NotificationChannelGroup> groups,
  ) async {
    await methodChannel.invokeMethod('createNotificationChannelGroups', {
      'groups': groups.map((group) => group.toJson()).toList(),
    });
  }

  @override
  Future<void> deleteNotificationChannel(String channelId) async {
    await methodChannel.invokeMethod('deleteNotificationChannel', {
      'channelId': channelId,
    });
  }

  @override
  Future<void> deleteNotificationChannelGroup(
    String groupId,
  ) async {
    await methodChannel.invokeMethod('deleteNotificationChannelGroup', {
      'groupId': groupId,
    });
  }

  @override
  Future<NotificationChannel?> getNotificationChannel(
    String channelId,
  ) async {
    final channel = await methodChannel
        .invokeMapMethod<String, dynamic>('getNotificationChannel', {
      'channelId': channelId,
    });
    return channel != null ? NotificationChannel.fromJson(channel) : null;
  }

  @override
  Future<List<NotificationChannel>> getNotificationChannels() async {
    final channels = await methodChannel.invokeListMethod<Map>(
      'getNotificationChannels',
    );
    return channels?.map((NotificationChannel.fromJson)).toList() ?? [];
  }

  @override
  Future<NotificationChannelGroup?> getNotificationChannelGroup(
    String groupId,
  ) async {
    final group = await methodChannel
        .invokeMapMethod<String, dynamic>('getNotificationChannelGroup', {
      'groupId': groupId,
    });
    return group != null ? NotificationChannelGroup.fromJson(group) : null;
  }

  @override
  Future<List<NotificationChannelGroup>> getNotificationChannelGroups() async {
    final groups = await methodChannel.invokeListMethod<Map>(
      'getNotificationChannelGroups',
    );
    return groups?.map((NotificationChannelGroup.fromJson)).toList() ?? [];
  }
}
