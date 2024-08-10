import 'dart:async';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/models/barkbuddy_action.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/services/models/user_service.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_ai_manager.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_tts_manager.dart';
import 'package:barkbuddy/home/pages/sitter/services/recorder/recorder_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

part 'sitter_event.dart';
part 'sitter_state.dart';

class SitterBloc extends Bloc<SitterEvent, SitterState> {
  static final logger = Logger(name: (SitterBloc).toString());
  static const double amplitudeThreshold = -30;

  final RecorderService audioRecorderService;
  final BarkbuddyAiManager barkbuddyAiManager;
  final DevicesManager devicesManager;
  final BarkbuddyTtsManager barkbuddyTtsManager;
  final ServicesService servicesService;

  late Timer volumeUpdateTimer;
  late Timer detectNoiseTimer;
  late Timer actionsPlayerTimer;
  bool isRecording;
  double minAmplitude;
  int recordSeconds;
  int volumeUpdateIntervalMillis;
  int detectNoiseIntervalMillis;
  int actionsPlayerIntervalMillis;
  StreamSubscription<RecorderUserService>? recorderSub;

  SitterBloc({
    required this.audioRecorderService,
    required this.barkbuddyAiManager,
    required this.devicesManager,
    required this.barkbuddyTtsManager,
    required this.servicesService,
    this.isRecording = false,
    this.minAmplitude = -45.0,
    this.recordSeconds = 10,
    this.detectNoiseIntervalMillis = 1000,
    this.volumeUpdateIntervalMillis = 50,
    this.actionsPlayerIntervalMillis = 3000,
  }) : super(SitterState()) {
    on<InitializeSitter>(onInitializeSitter);
    on<UpdateVolume>(onUpdateVolume);
    on<RecordNoise>(onRecordNoise);
    on<ExecuteAction>(onExecuteAction);
    on<DebugBark>(onDebugBark);
    on<AddActions>(onAddActions);
    on<RecorderUserServiceChanged>(onRecorderUserServiceChanged);
    audioRecorderService.audioRecordedCallback = audioRecordedCallback;
  }

  Future<void> onInitializeSitter(InitializeSitter event, Emitter<SitterState> emit) async {
    await audioRecorderService.initialize();
    // start timer
    volumeUpdateTimer =
        Timer.periodic(Duration(milliseconds: volumeUpdateIntervalMillis), (timer) async => await updateVolume());
    detectNoiseTimer =
        Timer.periodic(Duration(milliseconds: detectNoiseIntervalMillis), (timer) async => await detectNoise());
    actionsPlayerTimer =
        Timer.periodic(Duration(milliseconds: actionsPlayerIntervalMillis), (timer) async => await playAction());

    await recorderSub?.cancel();
    var recorderStream = await servicesService.streamRecorder();
    recorderSub = recorderStream.listen((recorder) => add(RecorderUserServiceChanged(recorderUserService: recorder)));
  }

  Future<void> updateVolume() async {
    double amplitude = await audioRecorderService.currentAmplitude;
    double volume = 0;
    if (amplitude > minAmplitude) {
      volume = (amplitude - minAmplitude) / minAmplitude;
    }

    add(UpdateVolume(volume: volume));
  }

  Future<void> onUpdateVolume(UpdateVolume event, Emitter<SitterState> emit) async {
    emit(state.copyWith(volume: event.volume, logDebugTransition: true));
  }

  Future<void> detectNoise() async {
    double amplitude = await audioRecorderService.currentAmplitude;

    if (amplitude > amplitudeThreshold && !isRecording) {
      // detected noise
      isRecording = true;
      add(RecordNoise());
    }
    // silence
    else if (isRecording) {
      logger.debug("audio recording currently in progress, skipping recorder restart");
    } else {
      await audioRecorderService.restartRecording();
    }
  }

  Future<void> onRecordNoise(RecordNoise event, Emitter<SitterState> emit) async {
    logger.info("Starting ${recordSeconds}s audio recording");
    await Future.delayed(Duration(seconds: recordSeconds), (() async {
      await stopRecording();
    }));
  }

  Future<void> stopRecording() async {
    logger.info("Stopping audio recording");
    await audioRecorderService.stopRecording();
  }

  Future<void> playAction() async {
    if(state.actionToExecute != null) {
      logger.debug("Skipping play action, last action is still being executed");
    } else if(state.actions.isNotEmpty) {
      BarkbuddyAction actionToExecute = state.actions.removeAt(0);
      logger.info("Playing next action: ${actionToExecute.action}");
      add(ExecuteAction(action: actionToExecute));
    } else {
      logger.debug("Skipping play action, there are no actions to execute");

    }
  }

  Future<void> onExecuteAction(ExecuteAction event, Emitter<SitterState> emit) async {
    logger.info("Executing action: ${state.actionToExecute?.action ?? "No action"}");
    emit(state.copyWith(actionToExecute: event.action));

    if (event.action.action == 'action_5' && event.action.message != null) {
      // todo make gemini generate title too
      await devicesManager.sendNotification(title: "Barking detected!", body: event.action.message!);
    }

    if (event.action.action == 'action_2' && event.action.message != null) {
      AudioPlayer audioPlayer = await barkbuddyTtsManager.synthesize(message: event.action.message!);
      await audioPlayer.play();
    }
    logger.debug("starting 10s action execution sleep");
    await Future.delayed(const Duration(seconds: 10));
    emit(state.copyWith(actionToExecute: null));
  }

  Future<void> audioRecordedCallback({required Uint8List audio, required int audioId}) async {
    logger.info("Received audio recorded event with id: $audioId and audio size: ${audio.length}");
    var barkingResponse = await barkbuddyAiManager.detectBarkingAndInferActionsFrom(audio: audio);
    if (barkingResponse.barking) {
      logger.info("Barking detected");
      add(AddActions(actions: barkingResponse.actions));
    } else {
      logger.debug("No barking");
    }
    isRecording = false;
  }

  void onAddActions(AddActions event, Emitter<SitterState> emit) {
    emit(state.copyWith(actions: [...state.actions, ...event.actions]));
  }

  Future<void> onDebugBark(DebugBark event, Emitter<SitterState> emit) async {
    await devicesManager.sendNotification(title: "Barking detected!", body: "bark!");
    await audioRecorderService.stopRecording();
  }

  void onRecorderUserServiceChanged(RecorderUserServiceChanged event, Emitter<SitterState> emit) {
    final bool showDebugBarkButton;
    if(event.recorderUserService != null) {
      showDebugBarkButton = kDebugMode || ! event.recorderUserService!.enabled;
    } else {
      showDebugBarkButton = true;
    }
    emit(state.copyWith(showDebugBarkButton: showDebugBarkButton));
  }

  @override
  Future<void> close() async {
    volumeUpdateTimer.cancel();
    detectNoiseTimer.cancel();
    actionsPlayerTimer.cancel();
    await recorderSub?.cancel();
    await super.close();
  }
}
