import 'dart:convert';

import 'package:barkbuddy/home/models/barkbuddy_action.dart';
import 'package:json_annotation/json_annotation.dart';

part '../../generated/home/models/barkbuddy_ai_response.g.dart';

@JsonSerializable(explicitToJson: true)
class BarkbuddyAiResponse {
  final String audioDescription;
  final bool barking;
  final String stressLevel;
  final List<BarkbuddyAction> actions;

  BarkbuddyAiResponse({
    required this.audioDescription,
    required this.stressLevel,
    required this.barking,
    this.actions = const [],
  });

  factory BarkbuddyAiResponse.fromJson(Map<String, dynamic> json) => _$BarkbuddyAiResponseFromJson(json);

  factory BarkbuddyAiResponse.fromJsonString(String json) => _$BarkbuddyAiResponseFromJson(jsonDecode(json));

  Map<String, dynamic> toJson() => _$BarkbuddyAiResponseToJson(this);
}
