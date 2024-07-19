import 'package:barkbuddy/common/settings.dart';
import 'package:barkbuddy/common/widgets/material_filled_button.dart';
import 'package:barkbuddy/common/widgets/vertical_space.dart';
import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:barkbuddy/home/models/barkbuddy_action.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioRecorderBloc>(
      create: (context) => AudioRecorderBloc(
        audioRecorderService: context.read<RecorderService>(),
        barkbuddyAiService: context.read<BarkbuddyAiService>(),
        notificationService: context.read<NotificationService>(),
      )..add(InitializeAudioRecorder()),
      child: Scaffold(
          body: Center(
            child: BlocBuilder<AudioRecorderBloc, AbstractAudioRecorderState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      switch (state) {
                        AudioRecorderState(volume: var volume) when state.hasData =>
                            Text("VOLUME\n${volume0to(volume, 100)}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 41, fontWeight: FontWeight.bold)),
                        _ => const CircularProgressIndicator()
                      },
                      VerticalSpace.medium(),
                      const CurrentAction(),
                      VerticalSpace.small(),
                      if(Settings.stub) MaterialFilledButton(label: const Text("bark!"), onPressed:
                          () => context.read<AudioRecorderBloc>().add(DebugBark()))
                    ],
                  );
                }),
          )),
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
        BlocBuilder<AudioRecorderBloc, AbstractAudioRecorderState> (
          builder: (context, state) {
            switch (state) {
              case AudioRecorderState(actionToExecute: var actionToExecute) when actionToExecute != null:
                var action = getDescription(actionToExecute);
                return Text(action);
              default:
                return const Text("no action to execute at the moment");
            }
          }
        ),
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
