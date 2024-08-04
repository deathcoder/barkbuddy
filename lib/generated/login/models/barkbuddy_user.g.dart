// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../login/models/barkbuddy_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarkbuddyUser _$BarkbuddyUserFromJson(Map<String, dynamic> json) =>
    BarkbuddyUser(
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      emailVerified: json['emailVerified'] as bool,
      isAnonymous: json['isAnonymous'] as bool,
      creationTimestamp: json['creationTimestamp'] == null
          ? null
          : DateTime.parse(json['creationTimestamp'] as String),
      lastSignInTime: json['lastSignInTime'] == null
          ? null
          : DateTime.parse(json['lastSignInTime'] as String),
      phoneNumber: json['phoneNumber'] as String?,
      photoUrl: json['photoUrl'] as String?,
      enabled: json['enabled'] as bool? ?? false,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$BarkbuddyUserToJson(BarkbuddyUser instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'email': instance.email,
      'emailVerified': instance.emailVerified,
      'isAnonymous': instance.isAnonymous,
      'creationTimestamp': instance.creationTimestamp?.toIso8601String(),
      'lastSignInTime': instance.lastSignInTime?.toIso8601String(),
      'phoneNumber': instance.phoneNumber,
      'photoUrl': instance.photoUrl,
      'uid': instance.uid,
      'enabled': instance.enabled,
    };
