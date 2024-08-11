import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/recorder_service.dart';
import 'package:flutter/foundation.dart';

class StubRecorderService implements RecorderService {
  static final logger = Logger(name: (StubRecorderService).toString());
  double _currentAmplitude = -40;

  Function({required Uint8List audio, required int audioId}) audioRecordedCallback =
      ({required Uint8List audio, required int audioId}) {
        logger.debug("audioRecordedCallback was not set");
      };

  @override
  Future<double> get currentAmplitude async => _currentAmplitude;

   void overrideCurrentAmplitude(double currentAmplitude) {
     _currentAmplitude = currentAmplitude;
   }

  @override
  Future<void> dispose() async {
    // Nothing to do here
  }

  @override
  Future<void> initialize() async {
    // Nothing to do here
  }

  @override
  Future<void> restartRecording() async {
    // Nothing to do here
  }

  @override
  Future<void> startRecording() async {
    // Nothing to do here
  }

  @override
  Future<void> stopRecording() async {
    audioRecordedCallback(audio: Uint8List(0), audioId: 0);
  }

}