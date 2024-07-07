import 'dart:async';
import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';

part 'audio_recorder_event.dart';

part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AbstractAudioRecorderState> {
  static final logger = Logger(name: (AudioRecorderBloc).toString());
  static final double amplitudThreshold = -30;
  bool initialized;
  bool isRecording;
  double minVolume;
  int recordSeconds;
  int audioId;

  Uint8List? currentAudio;
  late AudioRecorder audioRecorder;
  late Timer timer;

  StreamSubscription<Uint8List>? audioStream;

  AudioRecorderBloc({
    this.initialized = false,
    this.isRecording = false,
    this.minVolume = -45.0,
    this.recordSeconds = 3,
    this.audioId = 0,
  }) : super(const AudioRecorderState()) {
    on<InitializeAudioRecorder>(onInitialize);
    on<UpdateVolume>(onUpdateVolume);
    on<RestartRecorder>(onRestartRecorder);
    on<RecordNoise>(onRecordNoise);
    on<AudioRecorded>(onAudioRecorded);
  }

  Future<void> onInitialize(InitializeAudioRecorder event, Emitter<AbstractAudioRecorderState> emit) async {
    // avoid reinitialization
    if (initialized) {
      return;
    }

    // initialize audio recorder
    audioRecorder = AudioRecorder();
    // acquire permission
    if (await audioRecorder.hasPermission()) {
      if (!await audioRecorder.isRecording()) {
        // start recording
        audioStream = await startAudioStream();
      }
    }
    // start timer
    timer = Timer.periodic(const Duration(milliseconds: 300), (timer) => add(UpdateVolume()));

    initialized = true;
  }

  Future<void> onUpdateVolume(UpdateVolume event, Emitter<AbstractAudioRecorderState> emit) async {
    Amplitude ampl = await audioRecorder.getAmplitude();
    if (ampl.current > minVolume) {
      double volume = (ampl.current - minVolume) / minVolume;
      emit(AudioRecorderState(volume: volume));
    } else {
      emit(const AudioRecorderState(volume: 0));
    }

    if (ampl.current > amplitudThreshold && !isRecording) {
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

    await audioRecorder.cancel();
    await audioStream?.cancel();
    currentAudio = null;
    audioStream = await startAudioStream();
  }

  Future<void> onRecordNoise(RecordNoise event, Emitter<AbstractAudioRecorderState> emit) async {
    logger.info("Starting ${recordSeconds}s audio recording");
    await Future.delayed(Duration(seconds: recordSeconds), (() async {
      await stopRecording();
    }));
  }


  Future<void> onAudioRecorded(AudioRecorded event, Emitter<AbstractAudioRecorderState> emit) async {
    logger.info("Received audio recorded event with id: ${event.audioId} and audio size: ${event.audio.length}");
    isRecording = false;
  }

  Future<void> stopRecording() async {
    logger.info("Stopping audio recording");
    await audioRecorder.stop();
  }

  Future<StreamSubscription<Uint8List>> startAudioStream() async {
    if(await audioRecorder.isRecording()){
      String message = "start stream requested while audioRecorder is already recording";
      logger.error(message);
      throw Exception(message);
    }

    logger.info("starting audio recording with id: $audioId");
    return (await audioRecorder.startStream(const RecordConfig(
      encoder: AudioEncoder.pcm16bits
    ))).listen(
            (data) {
              logger.debug("Received audio data on stream, size: ${data.length}");
              if(currentAudio == null) {
                logger.debug("initializing current audio");
                currentAudio = data;
                return;
              }

              logger.debug("appending new data to existing audio with size: ${currentAudio!.length}");
              currentAudio = Uint8List.fromList(currentAudio! + data);
            },
        onDone: () {
          logger.info("current audio stream is done");
          add(AudioRecorded(audio: currentAudio!, audioId: audioId++));
        });
  }

  @override
  Future<void> close() async {
    timer.cancel();
    await audioStream?.cancel();
    await audioRecorder.dispose();
    await super.close();
  }

}
