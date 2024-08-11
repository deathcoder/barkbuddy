import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/devices/services/devices_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DevicesManager {
  static final logger = Logger(name: (DevicesManager).toString());

  final NotificationService notificationService;
  final DevicesService devicesService;
  final bool demo;

  DevicesManager({
    required this.notificationService,
    required this.devicesService,
    this.demo = false,
  });

  Future<void> registerDevice({required String name}) async {
    String? fcmToken = await notificationService.fcmToken;

    if (fcmToken == null) {
      throw "Unable to get fcmToken for the current device";
    }

    await devicesService.saveCurrentDevice(name: name, fcmToken: fcmToken);
  }

  Future<void> sendNotification(
      {required String title, required String body}) async {
    var devices = await devicesService.getDevices();


  // todo possibly remove this Fluttertoast.showToast(
  // todo possibly remove this   msg: body,
  // todo possibly remove this   toastLength: Toast.LENGTH_LONG,
  // todo possibly remove this   gravity: ToastGravity.CENTER,
  // todo possibly remove this   timeInSecForIosWeb: 10,
  // todo possibly remove this   webPosition: "center",
  // todo possibly remove this   // `left`, `center` or `right` https://github.com/apvarun/toastify-js?tab=readme-ov-file#documentation
  // todo possibly remove this   webBgColor: "#504338",
  // todo possibly remove this );

    if(demo) {
      return;
    }

    for (var device in devices) {
      logger.log("Sending notification title [$title], body [$body] to: [${device.name}]");

      await notificationService.sendNotification(title: title, body: body, fcmToken: device.fcmToken);
    }
  }
}
