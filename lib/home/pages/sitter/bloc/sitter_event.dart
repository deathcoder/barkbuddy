part of 'sitter_bloc.dart';

sealed class SitterEvent extends Equatable {
  const SitterEvent();
}

final class InitializeSitter extends SitterEvent {
  @override
  List<Object> get props => [];
}

final class UpdateVolume extends SitterEvent {
  final double volume;

  const UpdateVolume({required this.volume});

  @override
  List<Object> get props => [volume];
}

final class RecordNoise extends SitterEvent {
  @override
  List<Object> get props => [];
}

final class ExecuteAction extends SitterEvent {
  final BarkbuddyAction action;

  const ExecuteAction({required this.action});

  @override
  List<Object> get props => [action];
}

final class AddActions extends SitterEvent {
  final List<BarkbuddyAction> actions;

  const AddActions({required this.actions});

  @override
  List<Object> get props => [actions];
}

final class DebugBark extends SitterEvent {
  @override
  List<Object> get props => [];
}