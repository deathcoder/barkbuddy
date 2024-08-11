import 'dart:math';

import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/common/widgets/horizontal_space.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/devices/services/devices_service.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/bloc/sitter_bloc.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_tts_manager.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/stub_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/stub_recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/stub_tts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BarkbuddyTtsManager>(
            create: (context) => BarkbuddyTtsManager(
                  servicesService: context.read<ServicesService>(),
                  textToSpeechService: StubTtsService(),
                  demo: true,
                )),
      ],
      child: BlocProvider<SitterBloc>(
        create: (context) => SitterBloc(
          barkbuddyTtsManager: context.read<BarkbuddyTtsManager>(),
          audioRecorderService: StubRecorderService(),
          barkbuddyAiService: StubBarkbuddyAiService(),
          devicesManager: DevicesManager(
            notificationService: context.read<NotificationService>(),
            devicesService: context.read<DevicesService>(),
            demo: true,
          ),
          servicesService: context.read<ServicesService>(),
        )..add(InitializeSitter()),
        child: BlocBuilder<SitterBloc, SitterState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Welcome to BarkBuddy Demo Experience',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  VerticalSpace.small(),
                  Wrap(
                    children: [
                      _buildSoundDetectionSection(context, state.volume),
                      HorizontalSpace.small(),
                      _buildDogProfileSection(context),
                    ],
                  ),
                  VerticalSpace.medium(),
                  _buildFeaturesShowcase(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSoundDetectionSection(BuildContext context, double volume) {
    double occupiedSpace =
        175; // 100 rail + 16 padding left + 16 padding right, rounded up
    double halfAvailableSpace =
        (MediaQuery.of(context).size.width - occupiedSpace) / 2;
    double minWidth = 500;
    double maxWidth = max(minWidth, halfAvailableSpace);

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 500,
          maxWidth:
              minWidth == maxWidth ? double.infinity : halfAvailableSpace),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Sound Detection',
                      style: Theme.of(context).textTheme.headlineMedium),
                  HorizontalSpace.small(),
                  const Tooltip(
                    preferBelow: false,
                    message:
                        "In the demo experience there is no sound detection and no artificial intelligence processing",
                    child: Icon(Icons.info_outlined),
                  ),
                ],
              ),
              VerticalSpace.small(),
              const Text('Volume'),
              VerticalSpace.micro(),
              LinearProgressIndicator(
                value: volume.abs(),
                backgroundColor: Colors.grey[300],
                color: Colors.teal.shade700,
              ),
              VerticalSpace.small(),
              const SizedBox(
                height: 20,
              ),
              // make height the same as the dog profile
              ElevatedButton(
                child: const Text('Simulate Bark'),
                onPressed: () {
                  context.read<SitterBloc>().add(DebugBark());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDogProfileSection(BuildContext context) {
    double occupiedSpace =
        175; // 100 rail + 16 padding left + 16 padding right, rounded up
    double halfAvailableSpace =
        (MediaQuery.of(context).size.width - occupiedSpace) / 2;
    double minWidth = 500;
    double maxWidth = max(minWidth, halfAvailableSpace);

    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 500,
          maxWidth:
              minWidth == maxWidth ? double.infinity : halfAvailableSpace),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monitored Dogs',
                  style: Theme.of(context).textTheme.headlineMedium),
              VerticalSpace.small(),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(Assets.barkBuddyLogo),
                  ),
                  HorizontalSpace.small(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buddy',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Text('Golden Retriever, 3 years old'),
                    ],
                  ),
                ],
              ),
              VerticalSpace.small(),
              const Text('Status: Calm', style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesShowcase(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            Text('Key Features',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            _buildFeatureItem(Icons.mic, 'Advanced Bark Detection',
                'Identify and categorize different types of barks', context),
            _buildFeatureItem(Icons.show_chart, 'Stress Monitoring',
                'Track your dog\'s stress levels in real-time', context),
            _buildFeatureItem(Icons.notifications_active, 'Instant Alerts',
                'Get notified immediately about your dog\'s needs', context),
            _buildFeatureItem(Icons.psychology, 'AI-Powered Care',
                'Receive personalized care recommendations', context),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      IconData icon, String title, String description, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.teal),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}