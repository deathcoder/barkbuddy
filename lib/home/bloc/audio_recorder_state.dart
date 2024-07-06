part of 'audio_recorder_bloc.dart';

const double uninitializedVolume = -1;

sealed class AbstractAudioRecorderState extends Equatable {
  const AbstractAudioRecorderState();
}

final class AudioRecorderState extends AbstractAudioRecorderState {
  final double volume;

  const AudioRecorderState({this.volume = uninitializedVolume});

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object> get props => [volume];
}