part of 'audio_recorder_bloc.dart';

const double uninitializedVolume = -1;

sealed class AbstractAudioRecorderState extends Equatable {
  const AbstractAudioRecorderState();
}

final class AudioRecorderState extends AbstractAudioRecorderState {
  final double volume;
  final List<BarkbuddyAction> actions;
  final BarkbuddyAction? actionToExecute;
  final bool logDebugTransition;
  final DateTime noCache;

  AudioRecorderState({
    this.volume = uninitializedVolume,
    this.actions = const [],
    this.actionToExecute,
    this.logDebugTransition = false,
  }) : noCache = DateTime.now();

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object?> get props => [volume, actions, actionToExecute];
}
