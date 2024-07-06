import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:record/record.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioRecorder audioRecorder = AudioRecorder();
  Timer? timer;
  Stream<Uint8List>? audioStream;

  double volume = 0.0;
  double minVolume = -45.0;

  startTimer() async {
    timer ??= Timer.periodic(
        const Duration(milliseconds: 50), (timer) => updateVolume());
  }

  updateVolume() async {
    Amplitude ampl = await audioRecorder.getAmplitude();
    if (ampl.current > minVolume) {
      setState(() {
        volume = (ampl.current - minVolume) / minVolume;
      });
    }
  }

  int volume0to(int maxVolumeToDisplay) {
    return (volume * maxVolumeToDisplay).round().abs();
  }

  Future<bool> startRecording() async {
    if (await audioRecorder.hasPermission()) {
      if (!await audioRecorder.isRecording()) {
        audioStream = await audioRecorder.startStream(const RecordConfig());
      }
      startTimer();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Future<bool> recordFutureBuilder =
    Future<bool>.delayed(const Duration(seconds: 3), (() async {
      return startRecording();
    }));

    return FutureBuilder(
        future: recordFutureBuilder,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          return Scaffold(
            body: Center(
                child: snapshot.hasData
                    ? Text("VOLUME\n${volume0to(100)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 42, fontWeight: FontWeight.bold))
                    : const CircularProgressIndicator()),
          );
        });
  }
}
