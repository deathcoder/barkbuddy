import 'package:barkbuddy/home/models/action.dart';

class BarkbuddyAiResponse {
  final bool barking;
  final String stressLevel;
  final List<Action> actions;

  BarkbuddyAiResponse({required this.stressLevel, required this.barking, this.actions = const []});
}