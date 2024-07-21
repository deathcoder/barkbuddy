import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:barkbuddy/home/navigation/navigation_scaffold.dart';
import 'package:barkbuddy/home/pages/audio_recorder_page.dart';
import 'package:barkbuddy/home/pages/settings_page.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/services/tts/text_to_speech_service.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioRecorderBloc>(
      create: (context) => AudioRecorderBloc(
        textToSpeechService: context.read<TextToSpeechService>(),
        audioRecorderService: context.read<RecorderService>(),
        barkbuddyAiService: context.read<BarkbuddyAiService>(),
        notificationService: context.read<NotificationService>(),
      )..add(InitializeAudioRecorder()),
      child: NavigationScaffold(
        selectedIndex: selectedIndex,
        body: Center(
          child: selectedIndex == 0 ? const AudioRecorderPage() : const SettingsPage(),
        ),
        onDestinationSelected: onDestinationSelected,
      ),
    );
  }

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}