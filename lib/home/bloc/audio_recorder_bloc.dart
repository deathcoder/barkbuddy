import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/services/audio_recorder_service.dart';
import 'package:barkbuddy/home/services/barkbuddy_ai_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AbstractAudioRecorderState> {
  static final logger = Logger(name: (AudioRecorderBloc).toString());
  static const double amplitudeThreshold = -30;

  final AudioRecorderService audioRecorderService;
  final BarkbuddyAiService barkbuddyAiService;

  late Timer timer;
  bool isRecording;
  double minVolume;
  int recordSeconds;
  int audioUpdateIntervalMillis;

  AudioRecorderBloc({
    required this.audioRecorderService,
    required this.barkbuddyAiService,
    this.isRecording = false,
    this.minVolume = -45.0,
    this.recordSeconds = 3,
    this.audioUpdateIntervalMillis = 300
  }) : super(const AudioRecorderState()) {
    on<InitializeAudioRecorder>(onInitialize);
    on<UpdateVolume>(onUpdateVolume);
    on<RestartRecorder>(onRestartRecorder);
    on<RecordNoise>(onRecordNoise);
    on<AudioRecorded>(onAudioRecorded);
    audioRecorderService.onAudioRecorded = ({required Uint8List audio, required int audioId}) =>
        add(AudioRecorded(audioId: audioId, audio: audio));
  }

  Future<void> onInitialize(InitializeAudioRecorder event, Emitter<AbstractAudioRecorderState> emit) async {
    await audioRecorderService.initialize();
    // start timer
    timer = Timer.periodic(Duration(milliseconds: audioUpdateIntervalMillis), (timer) => add(UpdateVolume()));
  }

  Future<void> onUpdateVolume(UpdateVolume event, Emitter<AbstractAudioRecorderState> emit) async {
    Amplitude ampl = await audioRecorderService.getAmplitude();
    if (ampl.current > minVolume) {
      double volume = (ampl.current - minVolume) / minVolume;
      emit(AudioRecorderState(volume: volume));
    } else {
      emit(const AudioRecorderState(volume: 0));
    }

    if (ampl.current > amplitudeThreshold && !isRecording) {
      // detected noise
      isRecording = true;
      add(RecordNoise());
    } else {
      // silence
      add(RestartRecorder());
    }
  }

  Future<void> onRestartRecorder(RestartRecorder event, Emitter<AbstractAudioRecorderState> emit) async {
    if (isRecording) {
      logger.debug("audio recording currently in progress, skipping recorder restart");
      return;
    }

    await audioRecorderService.restart();
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
    } else {
      logger.debug("No barking");
    }
    isRecording = false;
  }

  Future<void> stopRecording() async {
    logger.info("Stopping audio recording");
    await audioRecorderService.stop();
  }


  @override
  Future<void> close() async {
    timer.cancel();
    await audioRecorderService.dispose();
    await super.close();
  }

}
