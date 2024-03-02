import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'notification_channel_group.g.dart';

/// A grouping of related notification channels. e.g., channels that all belong
/// to a single account.
@immutable
@JsonSerializable(
  explicitToJson: true,
  anyMap: true,
)
final class NotificationChannelGroup {
  /// The id of this group.
  final String id;

  /// The user visible name of this group.
  final String? name;

  /// The user visible description of this group.
  /// Requires Android P (API 28+)
  final String? description;

  const NotificationChannelGroup({
    required this.id,
    this.name,
    this.description,
  });

  factory NotificationChannelGroup.fromJson(Map<dynamic, dynamic> json) {
    return _$NotificationChannelGroupFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NotificationChannelGroupToJson(this);
  }
}
