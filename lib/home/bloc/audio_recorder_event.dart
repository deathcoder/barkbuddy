part of 'audio_recorder_bloc.dart';

sealed class AudioRecorderEvent extends Equatable {
  const AudioRecorderEvent();
}

final class InitializeAudioRecorder extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}

final class UpdateVolume extends AudioRecorderEvent {
  final double volume;

  const UpdateVolume({required this.volume});

  @override
  List<Object> get props => [volume];
}

final class RecordNoise extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}

final class ExecuteAction extends AudioRecorderEvent {
  final Action action;

  const ExecuteAction({required this.action});

  @override
  List<Object> get props => [action];
}

final class AddActions extends AudioRecorderEvent {
  final List<Action> actions;

  const AddActions({required this.actions});

  @override
  List<Object> get props => [actions];
}

final class DebugBark extends AudioRecorderEvent {
  @override
  List<Object> get props => [];
}