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
  final bool showDebugBarkButton;
  final DateTime noCache;

  SitterState({
    this.volume = uninitializedVolume,
    this.actions = const [],
    this.actionToExecute,
    this.logDebugTransition = false,
    this.showDebugBarkButton = false,
  }) : noCache = DateTime.now();

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object?> get props => [volume, actions, actionToExecute, noCache];

  SitterState copyWith({
    double? volume,
    List<BarkbuddyAction>? actions,
    BarkbuddyAction? actionToExecute,
    bool? logDebugTransition,
    bool? showDebugBarkButton,
  }) {
    return SitterState(
      volume: volume ?? this.volume,
      actions: actions ?? this.actions,
      actionToExecute: actionToExecute ?? this.actionToExecute,
      logDebugTransition: logDebugTransition ?? this.logDebugTransition,
      showDebugBarkButton: showDebugBarkButton ?? this.showDebugBarkButton,
    );
  }
}