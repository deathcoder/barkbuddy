// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../home/models/barkbuddy_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarkbuddyAction _$BarkbuddyActionFromJson(Map<String, dynamic> json) =>
    BarkbuddyAction(
      action: json['action'] as String,
      id: json['id'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BarkbuddyActionToJson(BarkbuddyAction instance) =>
    <String, dynamic>{
      'action': instance.action,
      'id': instance.id,
      'message': instance.message,
    };
