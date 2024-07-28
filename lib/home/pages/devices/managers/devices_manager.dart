import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/devices/services/devices_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';

class DevicesManager {
  static final logger = Logger(name: (DevicesManager).toString());

  final NotificationService notificationService;
  final DevicesService devicesService;

  DevicesManager({
    required this.notificationService,
    required this.devicesService,
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

    for (var device in devices) {
      logger.log("Sending notification title [$title], body [$body] to: [${device.name}]");

      await notificationService.sendNotification(title: title, body: body, fcmToken: device.fcmToken);
    }
  }
}
