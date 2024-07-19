import 'package:barkbuddy/home/models/barkbuddy_action.dart';

class BarkbuddyAiResponse {
  final bool barking;
  final String stressLevel;
  final List<BarkbuddyAction> actions;

  BarkbuddyAiResponse({required this.stressLevel, required this.barking, this.actions = const []});
}