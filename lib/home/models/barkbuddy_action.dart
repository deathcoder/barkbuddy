class BarkbuddyAction {
  final String action;
  final String? id;
  final String? message;

  BarkbuddyAction({required this.action, this.id, this.message});

  @override
  String toString() {
    return '{action: $action, id: $id, message: $message}';
  }
}