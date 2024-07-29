// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../home/pages/services/models/user_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeminiUserService _$GeminiUserServiceFromJson(Map<String, dynamic> json) =>
    GeminiUserService(
      enabled: json['enabled'] as bool,
      uid: json['uid'] as String? ?? Services.gemini,
    );

Map<String, dynamic> _$GeminiUserServiceToJson(GeminiUserService instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'enabled': instance.enabled,
    };

GoogleTextToSpeechUserService _$GoogleTextToSpeechUserServiceFromJson(
        Map<String, dynamic> json) =>
    GoogleTextToSpeechUserService(
      projectId: json['projectId'] as String,
      accessToken: json['accessToken'] as String,
      enabled: json['enabled'] as bool,
      uid: json['uid'] as String? ?? Services.googleTts,
    );

Map<String, dynamic> _$GoogleTextToSpeechUserServiceToJson(
        GoogleTextToSpeechUserService instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'projectId': instance.projectId,
      'accessToken': instance.accessToken,
      'enabled': instance.enabled,
    };
