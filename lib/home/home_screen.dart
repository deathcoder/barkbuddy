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
      )..add(InitializeAudioRecorder()),
      child: Scaffold(
          body: Center(
            child: BlocBuilder<AudioRecorderBloc, AbstractAudioRecorderState>(
                builder: (context, state) {
                  return switch (state) {
                    AudioRecorderState(volume: var volume) when state.hasData =>
                        Text("VOLUME\n${volume0to(volume, 100)}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
                    _ => const CircularProgressIndicator()
                  };
                }),
          )),
    );
  }

  int volume0to(double volume, int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }
}
