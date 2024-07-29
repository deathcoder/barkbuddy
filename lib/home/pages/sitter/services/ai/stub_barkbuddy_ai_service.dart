import 'dart:typed_data';

import 'package:barkbuddy/home/models/barkbuddy_action.dart';
import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';

class StubBarkbuddyAiService implements BarkbuddyAiService {
  @override
  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom({
    required Uint8List audio,
  }) async {
    return stubResponse();
  }

  BarkbuddyAiResponse stubResponse({barking = true, stressLevel = "low"}) {
    return BarkbuddyAiResponse(
        barking: barking,
        stressLevel: stressLevel,
        actions: [
          BarkbuddyAction(action: "action_1", id: "audio_1"),
          BarkbuddyAction(action: "action_2", message: "Good boy, everything is alright."),
          BarkbuddyAction(action: "action_3"),
          BarkbuddyAction(action: "action_4", id: "toy_1"),
          BarkbuddyAction(action: "action_5", message: "Dog seems a bit restless. Please check the camera and see if they need anything."),
        ],
        audioDescription: 'a dog barked once'
    );
  }

}