import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/audio_recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/stub_recorder_service.dart';

class SwitcherAwareRecorderService implements RecorderService {
  static final logger = Logger(name: (SwitcherAwareRecorderService).toString());

  final AudioRecorderService audioRecorderService;
  final StubRecorderService stubRecorderService;
  final ServicesService servicesService;
  // todo
  bool stub = false;

  SwitcherAwareRecorderService({
    required this.audioRecorderService,
    required this.stubRecorderService,
    required this.servicesService,
  });

  Future<RecorderService> get instance async {
    if (stub) {
      return stubRecorderService;
    }

    return audioRecorderService;
  }

  @override
  set audioRecordedCallback(void Function({required Uint8List audio, required int audioId}) onAudioRecorded) {
    instance.then((recorderService) => recorderService.audioRecordedCallback = onAudioRecorded);
  }

  @override
  Future<double> get currentAmplitude async {
    var recorderService = await instance;
    return await recorderService.currentAmplitude;
  }

  @override
  Future<void> dispose() async {
    await audioRecorderService.dispose();
    await stubRecorderService.dispose();
  }

  @override
  Future<void> initialize() async {
    try {
      var recorderUserService = await servicesService.getRecorderUserService();
      stub = !(recorderUserService?.enabled ?? false);
    } catch (error) {
      logger.warn("Error getting user services, will fallback to stub recorder service, error was: $error");
    }

    RecorderService recorderService = await instance;
    await recorderService.initialize();
  }

  @override
  Future<void> restartRecording() async {
    var recorderService = await instance;
    await recorderService.restartRecording();
  }

  @override
  Future<void> startRecording() async {
    var recorderService = await instance;
    await recorderService.startRecording();
  }

  @override
  Future<void> stopRecording() async {
    var recorderService = await instance;
    await recorderService.stopRecording();
  }
}
