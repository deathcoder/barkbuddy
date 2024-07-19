import 'dart:async';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final logger = Logger(name: (NotificationService).toString());
  
  late StreamSubscription<RemoteMessage> onMessageSubscription;
  
  Future<void> initialize() async {
    if (!kIsWeb) {
      await firebaseMessaging.requestPermission();
      onMessageSubscription = FirebaseMessaging.onMessage
          .listen((data) {
        logger.info("received notification");
      });
    }
  }

  Future<String?> get fcmToken async {
    final String fcmToken;
    try {
      if (!kIsWeb) {
        fcmToken = (await firebaseMessaging.getToken())!;
        logger.info(fcmToken);
        return fcmToken;
      }
      /* dont really need to receive notifications on web
      else {
        fcmToken = (await firebaseMessaging.getToken(vapidKey: DefaultFirebaseOptions.currentPlatform.vapidKey))!;
      }*/
    } catch (error) {
      debugPrint("error initializing FirebaseMessaging: $error");
    }
    return null;
  }

  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
  
  Future<void> dispose() async {
    await onMessageSubscription.cancel();
  }

  Future<void> sendNotification({required String message}) async {
    var token = await fcmToken;
    // call server api
    logger.log("sending notification message [$message] to: $token");
  }
}