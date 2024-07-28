// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../home/pages/devices/models/user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) => UserDevice(
      uid: json['uid'] as String?,
      platform: json['platform'] as String,
      fcmToken: json['fcmToken'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'platform': instance.platform,
      'name': instance.name,
      'fcmToken': instance.fcmToken,
    };
