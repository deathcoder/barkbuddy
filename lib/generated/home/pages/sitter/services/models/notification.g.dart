// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../../home/pages/sitter/services/models/notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
      'timestamp': instance.timestamp.toIso8601String(),
    };
