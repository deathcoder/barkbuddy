import 'dart:async';
import 'dart:convert';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FirebaseNotificationService implements NotificationService {
  static final logger = Logger(name: (FirebaseNotificationService).toString());
  static const String baseUrl = 'https://notification-5wt6kruwzq-uc.a.run.app';

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
    Fluttertoast.showToast(
      msg: body,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 10,
      webPosition: "center",
      // `left`, `center` or `right` https://github.com/apvarun/toastify-js?tab=readme-ov-file#documentation
      webBgColor: "#504338",
    );

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "title": title,
          "body": body,
          "token": fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        logger.log("Notification was sent successfully");
      } else {
        throw Exception(
            'Failed to send notification: statusCode ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to send notification: statusCode $error');
    }
  }
}
