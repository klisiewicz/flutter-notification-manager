// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_channel_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationChannelGroup _$NotificationChannelGroupFromJson(Map json) =>
    NotificationChannelGroup(
      id: json['id'] as String,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$NotificationChannelGroupToJson(
        NotificationChannelGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
