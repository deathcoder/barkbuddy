import 'dart:typed_data';

import 'package:barkbuddy/home/models/action.dart';
import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';

class StubBarkbuddyAiService implements BarkbuddyAiService {
  @override
  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom(Uint8List audio) async {
    return stubResponse();
  }

  BarkbuddyAiResponse stubResponse({barking = true, stressLevel = "low"}) {
    return BarkbuddyAiResponse(
        barking: barking,
        stressLevel: stressLevel,
        actions: [
          Action(action: "action_1", id: "audio_1"),
          Action(action: "action_2", message: "Good boy, everything is alright."),
          Action(action: "action_3"),
          Action(action: "action_4", id: "toy_1"),
          Action(action: "action_5", message: "Dog seems a bit restless. Please check the camera and see if they need anything."),
        ]
    );
  }

}