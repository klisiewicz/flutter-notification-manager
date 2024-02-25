// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChannel _$NotificationChannelFromJson(Map json) =>
    NotificationChannel(
      id: json['id'] as String,
      name: json['name'] as String,
      importance:
          $enumDecodeNullable(_$ImportanceEnumMap, json['importance']) ??
              Importance.normal,
      description: json['description'] as String?,
      groupId: json['groupId'] as String?,
      conversation: json['conversation'] == null
          ? null
          : Conversation.fromJson(
              Map<String, dynamic>.from(json['conversation'] as Map)),
      showBubble: json['showBubble'] as bool? ?? false,
      showBadge: json['showBadge'] as bool? ?? false,
      enableLights: json['enableLights'] as bool? ?? false,
      lightColor: _colorFromJson(json['lightColor'] as int?),
      enableVibrations: json['enableVibrations'] as bool? ?? false,
    );

Map<String, dynamic> _$NotificationChannelToJson(
        NotificationChannel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'importance': _$ImportanceEnumMap[instance.importance]!,
      'description': instance.description,
      'groupId': instance.groupId,
      'conversation': instance.conversation?.toJson(),
      'showBubble': instance.showBubble,
      'showBadge': instance.showBadge,
      'enableLights': instance.enableLights,
      'lightColor': _colorToJson(instance.lightColor),
      'enableVibrations': instance.enableVibrations,
    };

const _$ImportanceEnumMap = {
  Importance.max: 5,
  Importance.high: 4,
  Importance.normal: 3,
  Importance.low: 2,
  Importance.min: 1,
  Importance.none: 0,
  Importance.unspecified: -1000,
};

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
      parentChannelId: json['parentChannelId'] as String,
      conversationId: json['conversationId'] as String,
    );

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'parentChannelId': instance.parentChannelId,
      'conversationId': instance.conversationId,
    };
