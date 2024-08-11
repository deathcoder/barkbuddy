import 'dart:async';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseNotificationService implements NotificationService {
  static final logger = Logger(name: (FirebaseNotificationService).toString());
  static const String baseUrl = 'https://notification-5wt6kruwzq-lz.a.run.app';

  late StreamSubscription<RemoteMessage> onMessageSubscription;

  FirebaseNotificationService();

  @override
  Future<void> initialize() async {
    if (!kIsWeb) {
      await firebaseMessaging.requestPermission();
      onMessageSubscription = FirebaseMessaging.onMessage.listen((data) {
        // todo should show a local notification when the app is open
        logger.info("received notification");
      });
    }
  }

  @override
  Future<String?> get fcmToken async {
    final String fcmToken;
    try {
      if (!kIsWeb) {
        fcmToken = (await firebaseMessaging.getToken())!;
        logger.info(fcmToken);
        return fcmToken;
      }
    } catch (error) {
      logger.error("error initializing FirebaseMessaging: $error");
    }
    return null;
  }

  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  Future<void> dispose() async {
    await onMessageSubscription.cancel();
  }

  @override
  Future<void> sendNotification(
      {required String title,
      required String body,
      required String fcmToken}) async {

    try {
      final response =
          await FirebaseFunctions.instanceFor(region: 'europe-north1')
              .httpsCallable('notification',
                  options: HttpsCallableOptions(limitedUseAppCheckToken: true))
              .call({
        "title": title,
        "body": body,
        "token": fcmToken,
      });

      if (response.data?["status"] == "ok") {
        logger.log("Notification was sent successfully");
      } else {
        throw Exception('Failed to send notification: ${response.data}');
      }
    } catch (error) {
      throw Exception('Failed to send notification: $error');
    }
  }
}
