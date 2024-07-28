import 'package:barkbuddy/home/navigation/destination.dart';
import 'package:barkbuddy/home/navigation/navigation_scaffold.dart';
import 'package:barkbuddy/home/pages/devices/bloc/devices_bloc.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/devices/services/devices/devices_service.dart';
import 'package:barkbuddy/home/pages/sitter/bloc/sitter_bloc.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<SitterBloc>(
          create: (context) => SitterBloc(
            textToSpeechService: context.read<TextToSpeechService>(),
            audioRecorderService: context.read<RecorderService>(),
            barkbuddyAiService: context.read<BarkbuddyAiService>(),
            devicesManager: context.read<DevicesManager>(),
          )..add(InitializeSitter()),
        ),
        BlocProvider<DevicesBloc>(
          create: (context) =>
              DevicesBloc(devicesService: context.read<DevicesService>(),
                devicesManager: context.read<DevicesManager>()
              )
                ..add(const InitializeDevices()),
        ),
      ],
      child: NavigationScaffold(
        selectedIndex: selectedIndex,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: destinations[selectedIndex].builder(context)),
          ),
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
