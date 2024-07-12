part of 'audio_recorder_bloc.dart';

const double uninitializedVolume = -1;

sealed class AbstractAudioRecorderState extends Equatable {
  const AbstractAudioRecorderState();
}

final class AudioRecorderState extends AbstractAudioRecorderState {
  final double volume;
  final List<Action> actions;
  final Action? actionToExecute;

  const AudioRecorderState({this.volume = uninitializedVolume, this.actions = const [], this.actionToExecute});

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object?> get props => [volume, actions, actionToExecute];
}