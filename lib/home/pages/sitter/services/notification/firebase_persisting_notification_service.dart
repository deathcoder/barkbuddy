import 'package:barkbuddy/common/collections.dart';
import 'package:barkbuddy/home/pages/sitter/services/models/notification.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:barkbuddy/login/services/users/barkbuddy_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebasePersistingNotificationService implements NotificationService {
  final NotificationService delegate;
  final BarkbuddyUserService barkbuddyUserService;

  FirebaseFirestore db =
  FirebaseFirestore.instanceFor(app: Firebase.app(), databaseId: kDebugMode ? 'test' : 'prod');

  FirebasePersistingNotificationService({required this.delegate, required this.barkbuddyUserService});

  @override
  Future<String?> get fcmToken => delegate.fcmToken;

  @override
  Future<void> initialize() {
    return delegate.initialize();
  }

  @override
  Future<void> sendNotification({required String title, required String body, required String fcmToken}) async {
    await delegate.sendNotification(title: title, body: body, fcmToken: fcmToken);
    await storeNotification(title: title, body: body);

  }

  Future<void> storeNotification({required String title, required String body}) async {
    var timestamp = DateTime.now();
    var user = await barkbuddyUserService.getUser();
    if(user == null) {
      throw "User must be logged in to store notifications";
    }

    await db.collection(Collections.users.collection)
        .doc(user.uid)
        .collection(Collections.users.notifications.collection)
        .add(Notification(title: title, body: body, timestamp: timestamp).toJson());
  }

}