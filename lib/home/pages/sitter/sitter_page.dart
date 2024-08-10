import 'package:barkbuddy/common/widgets/empty_widget.dart';
import 'package:barkbuddy/common/widgets/material_filled_button.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/models/barkbuddy_action.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/bloc/sitter_bloc.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_ai_manager.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_tts_manager.dart';
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
          barkbuddyAiManager: context.read<BarkbuddyAiManager>(),
          devicesManager: context.read<DevicesManager>(),
          servicesService: context.read<ServicesService>(),
        )..add(InitializeSitter()),
        child: BlocBuilder<SitterBloc, SitterState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state.hasData
                  ? Text("VOLUME\n${volume0to(state.volume, 100)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 41, fontWeight: FontWeight.bold))
                  : const CircularProgressIndicator(),
              VerticalSpace.medium(),
              const CurrentAction(),
              VerticalSpace.small(),
              state.showDebugBarkButton
                  ? MaterialFilledButton(
                      label: const Text("bark!"),
                      onPressed: () =>
                          context.read<SitterBloc>().add(DebugBark()))
                  : const EmptyWidget()
            ],
          );
        }),
      ),
    );
  }

  int volume0to(double volume, int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }
}

class CurrentAction extends StatelessWidget {
  const CurrentAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Currently executing"),
        BlocBuilder<SitterBloc, SitterState>(builder: (context, state) {
          if (state.actionToExecute != null) {
            var action = getDescription(state.actionToExecute!);
            return Text(action);
          } else {
            return const Text("no action to execute at the moment");
          }
        }),
      ],
    );
  }

  String getDescription(BarkbuddyAction action) {
    switch (action.action) {
      case "action_1":
        return "Play pre-recorded audio ${action.id} by the owner.";
      case "action_2":
        return "Generate a custom message (this message will be played back to the dog using text-to-speech).";
      case "action_3":
        return "Activate feeder (a small amount of treats will be released to the dog).";
      case "action_4":
        return "Activate toy: ${getToyDescription(action.id)}.";
      case "action_5":
        return "Generate a notification message (this message will be sent to owner's device)";
      default:
        return "invalid action";
    }
  }

  String getToyDescription(String? id) {
    switch (id) {
      case "toy_1":
        return "electric mouse - once activated will run for 2 seconds";
      case "toy_2":
        return "squeaky bear - once activated will squeak 3 times every 3 seconds";
      default:
        return "invalid toy";
    }
  }
}
