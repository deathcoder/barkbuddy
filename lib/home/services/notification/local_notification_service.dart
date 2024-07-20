import 'package:fluttertoast/fluttertoast.dart';

import 'notification_service.dart';

class LocalNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    // nothing to do here
  }

  @override
  Future<String?> get fcmToken async => null;

  @override
  Future<void> sendNotification({required String message}) async {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        webPosition: "center", // `left`, `center` or `right` https://github.com/apvarun/toastify-js?tab=readme-ov-file#documentation
        webBgColor: "#504338",
    );
  }

}