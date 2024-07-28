import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DevicesPage extends StatelessWidget {
  final String? fcmToken = null;
  final bool isLoading = false;

  const DevicesPage({super.key});

  get kIsAndroidOrIos => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manage Your Devices',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        if (kIsAndroidOrIos) ...[
          const Text(
            'Mobile Device Registration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          if (isLoading && false)
            const CircularProgressIndicator()
          else if (fcmToken != null)
            //Text('FCM Token: ${_fcmToken!.substring(0, 20)}...'),
            const Text('FCM Token: <partial fcm token will go here>'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fcmToken != null ? _registerDevice : null,
            child: const Text('Register Device'),
          ),
        ] else
          Text(
            'To receive notifications, register your device by opening the app on your mobile phone.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
      ],
    );
  }

  Future<void> _registerDevice() async {
    if (fcmToken != null) {
      // TODO: Implement your API call to register the device
      print('Registering device with FCM token: $fcmToken');
    }
  }
}
