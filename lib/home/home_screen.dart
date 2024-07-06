import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AudioRecorderBloc>(
      create: (context) => AudioRecorderBloc()..add(InitializeAudioRecorder()),
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
