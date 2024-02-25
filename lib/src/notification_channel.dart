import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'notification_channel.g.dart';

@immutable
@JsonSerializable(
  explicitToJson: true,
  anyMap: true,
)

/// A representation of settings that apply to a collection of similarly
/// themed notifications.
final class NotificationChannel {
  /// The id of this channel.
  final String id;

  /// The user visible name of this channel.
  final String name;

  /// The user specified importance for notifications posted to this channel.
  final Importance importance;

  /// The user visible description of this channel.
  final String? description;

  /// The group this channel belongs to.
  final String? groupId;

  /// The conversation that this notification is associated with.
  /// Requires Android R (API 30+)
  final Conversation? conversation;

  /// Whether notifications posted to this channel are allowed to display
  /// outside of the notification shade, in a floating window on top of other apps.
  /// As of Android R (API 30+) this value is no longer respected.
  /// Requires Android Q (API 29)
  final bool showBubble;

  /// Whether notifications posted to this channel can appear as badges in
  /// a Launcher application.
  final bool showBadge;

  /// Whether notifications posted to this channel should display notification
  /// lights, on devices that support that feature.
  final bool enableLights;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)

  /// The notification light color for notifications posted to this channel.
  final Color? lightColor;

  /// Whether notification posted to this channel should vibrate.
  final bool enableVibrations;

  const NotificationChannel({
    required this.id,
    required this.name,
    this.importance = Importance.standard,
    this.description,
    this.groupId,
    this.conversation,
    this.showBubble = false,
    this.showBadge = false,
    this.enableLights = false,
    this.lightColor,
    this.enableVibrations = false,
  });

  factory NotificationChannel.fromJson(Map<dynamic, dynamic> json) {
    return _$NotificationChannelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NotificationChannelToJson(this);
  }
}

@JsonSerializable()
final class Conversation {
  /// The id of the parent notification channel to this channel.
  final String parentChannelId;

  /// The id of the conversation backing this channel.
  final String conversationId;

  Conversation({
    required this.parentChannelId,
    required this.conversationId,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return _$ConversationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ConversationToJson(this);
  }
}

@JsonEnum(valueField: 'value')
enum Importance {
  max(5),
  high(4),
  standard(3),
  low(2),
  min(1),
  none(0),
  unspecified(-1000),
  ;

  final int value;

  const Importance(this.value);
}

int? _colorToJson(Color? color) => color?.value;

Color? _colorFromJson(int? argb) => argb != null ? Color(argb) : null;
