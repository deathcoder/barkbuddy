import 'dart:io' show Platform;

import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/pages/devices/bloc/devices_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  get kIsAndroidOrIos => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, AbstractDevicesState>(
      builder: (context, state) {
        var registeredDevices = switch (state) {
          DevicesState(userDevices: var userDevices) => userDevices,
        }
            .toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Your Devices',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (kIsAndroidOrIos) ...[
                VerticalSpace.medium(),
                const Text(
                  'Mobile Device Registration',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                VerticalSpace.small(),
                ElevatedButton(
                  onPressed: () => _showRegisterDeviceDialog(context),
                  child: const Text('Register Device'),
                ),
              ] else
                Text(
                  'To receive notifications, register your device by opening the app on your mobile phone.',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.userDevices.length,
                itemBuilder: (context, index) {
                  final device = registeredDevices[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        device.platform == 'android'
                            ? Icons.android
                            : Icons.phone_iphone,
                        color: device.platform == 'android'
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(device.name),
                      subtitle: Text(
                          'FCM Token: ${device.fcmToken.substring(0, 10)}...'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context
                              .read<DevicesBloc>()
                              .add(DeleteDevice(deviceId: device.uid));
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRegisterDeviceDialog(BuildContext context) async {
    final TextEditingController nameController =
        TextEditingController(text: await _getDeviceModel());

    if (context.mounted) {
      return showDialog(
        context: context,
        builder: (childContext) {
          return AlertDialog(
            title: const Text('Register Device'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Device Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(childContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    _registerDevice(context, nameController.text);
                    Navigator.of(childContext).pop();
                  }
                },
                child: const Text('Register'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<String?> _getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      var webBrowserInfo = await deviceInfo.webBrowserInfo;
      return webBrowserInfo.userAgent;
    }
    if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.model;
    }
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.model;
    }

    return null;
  }

  void _registerDevice(BuildContext context, String deviceName) {
    context.read<DevicesBloc>().add(RegisterDevice(deviceName: deviceName));
  }
}
