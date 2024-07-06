part of 'audio_recorder_bloc.dart';

sealed class AudioRecorderEvent extends Equatable {
  const AudioRecorderEvent();
}

final class InitializeAudioRecorder extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}

final class UpdateVolume extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}
