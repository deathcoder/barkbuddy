import 'package:barkbuddy/common/settings.dart';
import 'package:barkbuddy/common/widgets/material_filled_button.dart';
import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
