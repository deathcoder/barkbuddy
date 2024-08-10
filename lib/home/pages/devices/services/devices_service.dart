import 'dart:io';

import 'package:barkbuddy/common/collections.dart';
import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/devices/models/user_device.dart';
import 'package:barkbuddy/login/services/users/barkbuddy_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DevicesService {
  static final logger = Logger(name: (DevicesService).toString());

  final FirebaseFirestore db =
      FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: kDebugMode ? 'test' : 'prod');

  final BarkbuddyUserService userService;

  DevicesService({required this.userService});

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

  Future<UserDevices> getDevices() async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to see their devices";
    }
    var devicesSnapshot = await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.devices.collection)
        .get();

    return devicesSnapshot.docs
        .where((doc) => doc.exists)
        .map((doc) => UserDevice.fromJson(doc.data()));
  }

  Future<void> saveCurrentDevice({required String name, required String fcmToken}) async {
    var user = await userService.getUser();
    if(user == null) {
      throw "Users must be logged in to save their devices";
    }

    String platform = kIsWeb ? "web" : Platform.operatingSystem;

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
