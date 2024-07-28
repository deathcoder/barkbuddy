import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part '../../../../generated/home/pages/devices/models/user_device.g.dart';

@JsonSerializable()
class UserDevice {
  final String uid;
  final String platform;
  final String name;
  final String fcmToken;

  UserDevice._({
    required this.uid,
    required this.platform,
    required this.fcmToken,
    required this.name,
  });

  factory UserDevice({
    String? uid,
    required String platform,
    required String fcmToken,
    required String name,
  }) {
    return UserDevice._(
      uid: uid ?? const Uuid().v4(),
      platform: platform,
      fcmToken: fcmToken,
      name: name,
    );
  }

  factory UserDevice.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$UserDeviceToJson(this);
}

typedef UserDevices = Iterable<UserDevice>;
