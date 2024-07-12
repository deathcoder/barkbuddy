import 'dart:typed_data';
import 'dart:ui';

import 'package:barkbuddy/common/widgets/material_filled_button.dart';
import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:barkbuddy/home/services/audio_recorder_service.dart';
import 'package:barkbuddy/home/services/barkbuddy_ai_service.dart';
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
        audioRecorderService: AudioRecorderService(),
        barkbuddyAiService: BarkbuddyAiService(apiKey: ""),
      )..add(InitializeAudioRecorder())..add(UpdateVolume()),
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
                      MaterialFilledButton(label: Text("bark!"), onPressed: () => context.read<AudioRecorderBloc>().add(AudioRecorded(audio: Uint8List(0), audioId: 0)))
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
