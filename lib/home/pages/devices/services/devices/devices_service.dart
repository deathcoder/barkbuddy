import 'dart:io';

import 'package:barkbuddy/common/collections.dart';
import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/devices/models/user_device.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:barkbuddy/login/services/users/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DevicesService {
  static final logger = Logger(name: (DevicesService).toString());

  // todo should be able to use prod in production builds
  final FirebaseFirestore db =
      FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: 'test');

  final UserService userService;
  final NotificationService notificationService;

  DevicesService({required this.userService, required this.notificationService});

  Future<Stream<UserDevices>> streamDevices() async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to see their devices";
    }
    return db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.devices.collection)
        .snapshots()
        .map((data) => data.docs)
        .map((docs) => docs.where((doc) => doc.exists).map((doc) => UserDevice.fromJson(doc.data())));
  }

  Future<void> saveCurrentDevice({required String name}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to save their devices";
    }

    String platform = kIsWeb ? "web" : Platform.operatingSystem;
    String? fcmToken = await notificationService.fcmToken;

    if(fcmToken == null) {
      throw "Unable to get fcmToken for the current device";
    }

    var userDevice = UserDevice(platform: platform, fcmToken: fcmToken, name: name);

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.devices.collection)
        .doc(userDevice.uid)
        .set(userDevice.toJson());
  }

  Future<void> deleteDevice({required String deviceId}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to delete their devices";
    }

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.devices.collection)
        .doc(deviceId)
        .delete();
  }
}
