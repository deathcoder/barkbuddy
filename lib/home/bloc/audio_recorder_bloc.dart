import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/models/action.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AbstractAudioRecorderState> {
  static final logger = Logger(name: (AudioRecorderBloc).toString());
  static const double amplitudeThreshold = -30;

  final RecorderService audioRecorderService;
  final BarkbuddyAiService barkbuddyAiService;

  late Timer volumeUpdateTimer;
  late Timer detectNoiseTimer;
  late Timer actionsPlayerTimer;
  bool isRecording;
  double minAmplitude;
  int recordSeconds;
  int volumeUpdateIntervalMillis;
  int detectNoiseIntervalMillis;
  int actionsPlayerIntervalMillis;

  AudioRecorderBloc({
    required this.audioRecorderService,
    required this.barkbuddyAiService,
    this.isRecording = false,
    this.minAmplitude = -45.0,
    this.recordSeconds = 3,
    this.detectNoiseIntervalMillis = 300,
    this.volumeUpdateIntervalMillis = 50,
    this.actionsPlayerIntervalMillis = 3000,
  }) : super(AudioRecorderState()) {
    on<InitializeAudioRecorder>(onInitialize);
    on<UpdateVolume>(onUpdateVolume);
    on<DetectNoise>(onDetectNoise);
    on<PlayAction>(onPlayAction);
    on<RestartRecorder>(onRestartRecorder);
    on<RecordNoise>(onRecordNoise);
    on<AudioRecorded>(onAudioRecorded);
    on<ExecuteAction>(onExecuteAction);
    audioRecorderService.audioRecordedCallback = ({required Uint8List audio, required int audioId}) =>
        add(AudioRecorded(audioId: audioId, audio: audio));
  }

  Future<void> onInitialize(InitializeAudioRecorder event, Emitter<AbstractAudioRecorderState> emit) async {
    await audioRecorderService.initialize();
    // start timer
    volumeUpdateTimer = Timer.periodic(Duration(milliseconds: volumeUpdateIntervalMillis), (timer) => add(UpdateVolume()));
    detectNoiseTimer = Timer.periodic(Duration(milliseconds: detectNoiseIntervalMillis), (timer) => add(DetectNoise()));
    actionsPlayerTimer = Timer.periodic(Duration(milliseconds: actionsPlayerIntervalMillis), (timer) => add(PlayAction()));
  }



  Future<void> onDetectNoise(DetectNoise event, Emitter<AbstractAudioRecorderState> emit) async {
    double amplitude = await audioRecorderService.currentAmplitude;

    if (amplitude > amplitudeThreshold && !isRecording) {
      // detected noise
      isRecording = true;
      add(RecordNoise());
    } else {
      // silence
      add(RestartRecorder());
    }
  }

  Future<void> onUpdateVolume(UpdateVolume event, Emitter<AbstractAudioRecorderState> emit) async {
    double amplitude = await audioRecorderService.currentAmplitude;
    double volume = 0;
    if (amplitude > minAmplitude) {
      volume = (amplitude - minAmplitude) / minAmplitude;
    }

    switch(state) {
      case AudioRecorderState(actions: var actions, actionToExecute: var actionToExecute):
        emit(AudioRecorderState(volume: volume, actions: actions, actionToExecute: actionToExecute));
    }
  }

  Future<void> onRestartRecorder(RestartRecorder event, Emitter<AbstractAudioRecorderState> emit) async {
    if (isRecording) {
      logger.debug("audio recording currently in progress, skipping recorder restart");
      return;
    }

    await audioRecorderService.restartRecording();
  }

  Future<void> onRecordNoise(RecordNoise event, Emitter<AbstractAudioRecorderState> emit) async {
    logger.info("Starting ${recordSeconds}s audio recording");
    await Future.delayed(Duration(seconds: recordSeconds), (() async {
      await stopRecording();
    }));
  }


  Future<void> onAudioRecorded(AudioRecorded event, Emitter<AbstractAudioRecorderState> emit) async {
    logger.info("Received audio recorded event with id: ${event.audioId} and audio size: ${event.audio.length}");
    var barkingResponse = await barkbuddyAiService.detectBarkingAndInferActionsFrom(event.audio);
    if(barkingResponse.barking) {
      logger.warn("Barking detected");
      switch(state) {
        case AudioRecorderState(volume: var volume, actions: var actions, actionToExecute: var actionToExecute):
          emit(AudioRecorderState(volume: volume, actionToExecute: actionToExecute, actions: actions + barkingResponse.actions));
      }
    } else {
      logger.debug("No barking");
    }
    isRecording = false;
  }

  Future<void> stopRecording() async {
    logger.info("Stopping audio recording");
    await audioRecorderService.stopRecording();
  }


  @override
  Future<void> close() async {
    volumeUpdateTimer.cancel();
    detectNoiseTimer.cancel();
    actionsPlayerTimer.cancel();
    await audioRecorderService.dispose();
    await super.close();
  }


  Future<void> onPlayAction(PlayAction event, Emitter<AbstractAudioRecorderState> emit) async {
    switch (state) {
      case AudioRecorderState(actionToExecute: var actionToExecute) when actionToExecute != null:
        logger.debug("Skipping play action, last action is still being executed");
      case AudioRecorderState(volume: var volume, actions: var actions) when actions.isNotEmpty:
        Action actionToExecute = actions.removeAt(0);
        logger.info("Playing next action: ${actionToExecute.action}");
        emit(AudioRecorderState(volume: volume, actions: actions, actionToExecute: actionToExecute));
        add(ExecuteAction(action: actionToExecute));
      default:
        logger.debug("Skipping play action, there are no actions to execute");
    }
  }

  Future<void> onExecuteAction(ExecuteAction event, Emitter<AbstractAudioRecorderState> emit) async {
    await Future.delayed(const Duration(seconds: 10));
    switch(state) {
      case AudioRecorderState(actionToExecute: var actionToExecute, volume: var volume, actions: var actions):
        logger.info("Executing action: ${actionToExecute?.action?? "No action"}");
        emit(AudioRecorderState(volume: volume, actions: actions, actionToExecute: null));
    }
  }
}
