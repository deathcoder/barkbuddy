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

final class RecordNoise extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}

final class RestartRecorder extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}

final class AudioRecorded extends AudioRecorderEvent {
  final int audioId;
  final Uint8List audio;

  const AudioRecorded({required this.audioId, required this.audio});

  @override
  List<Object> get props => [audioId];
}