import 'dart:math';

import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/common/widgets/horizontal_space.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/models/barkbuddy_action.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/bloc/sitter_bloc.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_tts_manager.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/audio_recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/stub_recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/switcher_aware_recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SitterPage extends StatelessWidget {
  const SitterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RecorderService>(
          create: (context) => SwitcherAwareRecorderService(
            audioRecorderService: AudioRecorderService(),
            stubRecorderService: StubRecorderService(),
            servicesService: context.read<ServicesService>(),
          )..initialize(),
          dispose: (context, value) async => await value.dispose(),
        ),
        Provider<BarkbuddyTtsManager>(
            create: (context) => BarkbuddyTtsManager(
              servicesService: context.read<ServicesService>(),
              textToSpeechService: context.read<TextToSpeechService>(),
            )),
      ],
      child: BlocProvider<SitterBloc>(
        create: (context) => SitterBloc(
          barkbuddyTtsManager: context.read<BarkbuddyTtsManager>(),
          audioRecorderService: context.read<RecorderService>(),
          barkbuddyAiService: context.read<BarkbuddyAiService>(),
          devicesManager: context.read<DevicesManager>(),
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
                    'Welcome to BarkBuddy AI Experience',
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
                  VerticalSpace.small(),
                  CurrentActionCard(currentAction: state.actionToExecute,),
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
              const SizedBox(height: 20,),
              const Text('Volume'),
              VerticalSpace.micro(),
              LinearProgressIndicator(
                value: volume.abs(),
                backgroundColor: Colors.grey[300],
                color: Colors.teal.shade700,
              ),
              VerticalSpace.small(),
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
                      Text('Luna',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Text('Italian Greyhound, 10 months old'),
                    ],
                  ),
                ],
              ),
             // todo VerticalSpace.small(),
              // todo const Text('Status: Calm', style: TextStyle(color: Colors.green)),
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

class CurrentActionCard extends StatelessWidget {
  final BarkbuddyAction currentAction;

  const CurrentActionCard({super.key, required this.currentAction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Action',
                    style: Theme.of(context).textTheme.headlineMedium,//?.copyWith(color: Colors.white),
                  ),
                  VerticalSpace.small(),
                  _buildActionContent(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionContent(BuildContext context) {
    IconData icon;
    String actionText;
    Color iconColor = Colors.teal;

    switch (currentAction.action) {
      case 'action_1':
        // todo
        //icon = Icons.music_note;
        //actionText = 'Playing pre-recorded audio ${currentAction.id}';
        icon = Icons.pause;
        actionText = 'No action is currently executing';
        iconColor = Colors.grey[400]!;
        break;
      case 'action_2':
        icon = Icons.record_voice_over;
        actionText = 'Playing custom message: "${currentAction.message}"';
        break;
      case 'action_3':
        icon = Icons.food_bank;
        actionText = 'Activating feeder';
        break;
      case 'action_4':
        icon = Icons.toys;
        actionText = 'Activating toy ${currentAction.id}';
        break;
      case 'action_5':
        icon = Icons.notifications_active;
        actionText = 'Sending notification: "${currentAction.message}"';
        break;
      case BarkbuddyAction.noAction:
        icon = Icons.pause;
        actionText = 'No action is currently executing';
        iconColor = Colors.grey[400]!;
      default:
        icon = Icons.error;
        actionText = 'Unknown action';
    }

    return Row(
      children: [
        Icon(icon, color: iconColor),
        HorizontalSpace.small(),
        Expanded(
          child: Text(
            actionText,
          ),
        ),
      ],
    );
  }
}