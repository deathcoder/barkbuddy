import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/models/action.dart';
import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pcmtowave/convertToWav.dart';
import 'package:pcmtowave/pcmtowave.dart';

class BarkbuddyAiService {
  static final logger = Logger(name: (BarkbuddyAiService).toString());

  bool apiCalled = false;
  static const systemPrompt = """
You are a sophisticated multimodal language model designed to assist in monitoring and interacting with a dog. Your input is a short audio clip. Your task is to detect any barking in the audio, assess the dog's stress level, and generate a suitable action plan from the available options.

Tasks:

1) Detect Barking:
Analyze the provided audio clip for any instances of barking.

2) Evaluate Stress Level:
Consider the frequency and intensity of barking to evaluate the dog's current stress level.

3) Generate Actions:
Based on the detected stress level, choose appropriate actions from the following list:
action_1: Play pre-recorded audio {audio_id} by the owner.
action_2: Generate a custom message (this message will be played back to the dog using text-to-speech).
action_3: Activate feeder (a small amount of treats will be released to the dog).
action_4: Activate toy {toy_id}.
action_5: Generate a notification message (this message will be sent to owner's device)

Pre-recorded Audios:

{"audio_id": "audio_1", "description": "hi in cheerful voice"}
{"audio_id": "audio_2", "description": "good girl"}
{"audio_id": "audio_3", "description": "i'll be back soon"}

Toys:

{"toy_id": "toy_1", "description": "electric mouse - once activated will run for 2 seconds"}
{"toy_id": "toy_2", "description": "squeaky bear - once activated will squeak 3 times every 3 seconds"}

Output:
- a barking boolean field, if barking has been detected
- a stress level string field
- a list of actions to be taken to help alleviate the dog's stress with the following format:
  - each action in the list must contain an action field identifying the action to be taken, an optional id field identifying the id of the audio or toy and an optional message field with a generated message when appropriate
  
Example Output:
{
  "barking": true,
  "stress_level": "high",
  "actions": [
    {"action": "action_1", "id": "audio_3"},
    {"action": "action_3"},
    {"action": "action_4", "id": "toy_1"},
    {"action": "action_5", "message": "Dog seems a bit restless. Please check the camera and see if they need anything."}
  ]
}  
""";

  final GenerativeModel model;

  BarkbuddyAiService({required String apiKey, String model = "gemini-1.5-flash-latest"})
      : model = GenerativeModel(model: model, apiKey: apiKey);

  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom(Uint8List audio) async {
    return mockResponse();
    /*
    if(apiCalled) {
      return BarkbuddyAiResponse(barking: false);
    }

    apiCalled = true;
    final prompt = [
      Content.multi([
        TextPart(systemPrompt),
        // todo: audio mime type should come from audio_recorder_service
        DataPart('audio/wav', Pcmtowave.pcmToWav(audio, 44100, 1))
      ])
    ];
    GenerateContentResponse generateContentResponse = await model.generateContent(prompt);
    // todo: generate json flag? current output has markdown syntax
    //   generation_config={"response_mime_type": "application/json"}
    if(generateContentResponse.text != null){
      logger.info("Computer says: ${generateContentResponse.text}");
      return BarkbuddyAiResponse(barking: true);
    } else {
      logger.warn("Computer says no :(");
      return BarkbuddyAiResponse(barking: false);
    }
    */
  }

  BarkbuddyAiResponse mockResponse({barking = true, stressLevel = "low"}) {
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
