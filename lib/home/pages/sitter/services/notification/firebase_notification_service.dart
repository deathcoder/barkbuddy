import 'dart:async';
import 'dart:convert';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class FirebaseNotificationService implements NotificationService {
  static final logger = Logger(name: (FirebaseNotificationService).toString());
  static const String baseUrl = 'https://notification-5wt6kruwzq-uc.a.run.app';

  late StreamSubscription<RemoteMessage> onMessageSubscription;

  @override
  Future<void> initialize() async {
    if (!kIsWeb) {
      await firebaseMessaging.requestPermission();
      onMessageSubscription = FirebaseMessaging.onMessage.listen((data) {
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
      debugPrint("error initializing FirebaseMessaging: $error");
    }
    return null;
  }

  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  Future<void> dispose() async {
    await onMessageSubscription.cancel();
  }

  // todo send notification could be refactored it's duplicated at the moment
  @override
  Future<void> sendNotification(
      {required String title, required String body}) async {
    // call server api
    // TODO
    logger.log("sending notification title [$title], body [$body] to: TODO");

      try {
        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "title": title,
            "body": body,
            // todo token should be dynamic, but can't retrieve it with function, since browser is sending the notification but the phone needs to receive it so we dont need browser token but the phone one
            "token": "cy1RFneFSZK2KtgA8QLWiR:APA91bG2cI5tddjNpS6DUNNqgIIqJ-lOv0aIeJuS1MoLYzgz2Fd4cBB_C1jITmMt_YQhgLfZgjrCLzpCIsU6WVeHCFqQUNIAuSCaO7mITw-9hCN1_B9A7UU-i1dH4HU3ZMdpObYzIYY9",
          }),
        );

        if (response.statusCode == 200) {
          logger.log("Notification was sent successfully");
        } else {
          throw Exception(
              'Failed to send notification: statusCode ${response.statusCode}');
        }
      } catch (error) {
        throw Exception(
            'Failed to send notification: statusCode $error');
      }
  }
}
