// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../home/models/barkbuddy_ai_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarkbuddyAiResponse _$BarkbuddyAiResponseFromJson(Map<String, dynamic> json) =>
    BarkbuddyAiResponse(
      audioDescription: json['audioDescription'] as String,
      stressLevel: json['stressLevel'] as String,
      barking: json['barking'] as bool,
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => BarkbuddyAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BarkbuddyAiResponseToJson(
        BarkbuddyAiResponse instance) =>
    <String, dynamic>{
      'audioDescription': instance.audioDescription,
      'barking': instance.barking,
      'stressLevel': instance.stressLevel,
      'actions': instance.actions.map((e) => e.toJson()).toList(),
    };
