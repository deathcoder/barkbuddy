part of 'sitter_bloc.dart';

const double uninitializedVolume = -1;

sealed class AbstractSitterState extends Equatable {
  const AbstractSitterState();
}

final class SitterState extends AbstractSitterState {
  final double volume;
  final List<BarkbuddyAction> actions;
  final BarkbuddyAction? actionToExecute;
  final bool logDebugTransition;
  final DateTime noCache;

  SitterState({
    this.volume = uninitializedVolume,
    this.actions = const [],
    this.actionToExecute,
    this.logDebugTransition = false,
  }) : noCache = DateTime.now();

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object?> get props => [volume, actions, actionToExecute, noCache];
}
