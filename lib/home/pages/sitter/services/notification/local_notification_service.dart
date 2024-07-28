import 'dart:convert';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  static final logger = Logger(name: (LocalNotificationService).toString());
  static const String baseUrl = 'https://notification-5wt6kruwzq-uc.a.run.app/';

  @override
  Future<void> initialize() async {
    // nothing to do here
  }

  @override
  Future<String?> get fcmToken async => null;

  @override
  Future<void> sendNotification({required String title, required String body}) async {
    Fluttertoast.showToast(
        msg: body,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webPosition: "center", // `left`, `center` or `right` https://github.com/apvarun/toastify-js?tab=readme-ov-file#documentation
        webBgColor: "#504338",
    );

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