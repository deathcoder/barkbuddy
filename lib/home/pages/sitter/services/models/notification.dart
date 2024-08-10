import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/home/pages/sitter/services/models/notification.g.dart';

@JsonSerializable()
class Notification {
  final String title;
  final String body;
  final DateTime timestamp;

  Notification({required this.title, required this.body, required this.timestamp});

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}