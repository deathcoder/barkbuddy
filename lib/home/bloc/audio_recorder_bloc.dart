import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AbstractAudioRecorderState> {

  bool initialized;
  double minVolume;

  late AudioRecorder audioRecorder;
  late Timer timer;
  Stream<Uint8List>? audioStream;

  AudioRecorderBloc({this.initialized = false, this.minVolume = -45.0}) :
        super(const AudioRecorderState()) {
    on<InitializeAudioRecorder>(onInitialize);
    on<UpdateVolume>(onUpdateVolume);
  }

  Future<void> onInitialize(
      InitializeAudioRecorder event,
      Emitter<AbstractAudioRecorderState> emit) async {
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
        audioStream = await audioRecorder.startStream(const RecordConfig());
      }
    }
    // start timer
    timer = Timer.periodic(
        const Duration(milliseconds: 50), (timer) => add(UpdateVolume()));

    initialized = true;
  }

  Future<void> onUpdateVolume(UpdateVolume event, Emitter<AbstractAudioRecorderState> emit) async {
    Amplitude ampl = await audioRecorder.getAmplitude();
    if (ampl.current > minVolume) {
      double volume = (ampl.current - minVolume) / minVolume;
      emit(AudioRecorderState(volume: volume));
    }
  }

  @override
  Future<void> close() async {
    timer.cancel();
    await audioRecorder.cancel();
    await audioStream?.drain();
  }
}
