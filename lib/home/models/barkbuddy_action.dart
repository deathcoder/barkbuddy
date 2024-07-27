import 'package:json_annotation/json_annotation.dart';

part '../../generated/home/models/barkbuddy_action.g.dart';

@JsonSerializable()
class BarkbuddyAction {
  final String action;
  final String? id;
  final String? message;

  BarkbuddyAction({required this.action, this.id, this.message});

  @override
  String toString() {
    return '{action: $action, id: $id, message: $message}';
  }

  factory BarkbuddyAction.fromJson(Map<String, dynamic> json) => _$BarkbuddyActionFromJson(json);

  Map<String, dynamic> toJson() => _$BarkbuddyActionToJson(this);
}