part of 'sitter_bloc.dart';

const double uninitializedVolume = -1;

final class SitterState extends Equatable {
  final double volume;
  final List<BarkbuddyAction> actions;
  final BarkbuddyAction actionToExecute;
  final bool logDebugTransition;
  final bool showDebugBarkButton;
  final DateTime noCache;

  SitterState({
    this.volume = uninitializedVolume,
    this.actions = const [],
    BarkbuddyAction? actionToExecute,
    this.logDebugTransition = false,
    this.showDebugBarkButton = false,
  }) : noCache = DateTime.now(), actionToExecute = actionToExecute ?? BarkbuddyAction.noOp();

  bool get hasData => volume != uninitializedVolume;

  @override
  List<Object?> get props => [volume, actions, actionToExecute, logDebugTransition, showDebugBarkButton, noCache];

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
      logDebugTransition: logDebugTransition ?? false, // always reset to false unless explicitly set to true
      showDebugBarkButton: showDebugBarkButton ?? this.showDebugBarkButton,
    );
  }
}