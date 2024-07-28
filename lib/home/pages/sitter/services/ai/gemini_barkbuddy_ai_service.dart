import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pcmtowave/pcmtowave.dart';

class GeminiBarkbuddyAiService implements BarkbuddyAiService {
  static final logger = Logger(name: (GeminiBarkbuddyAiService).toString());

  static const String model = "gemini-1.5-flash-latest";

  static const systemPrompt = """
You are a sophisticated multimodal language model designed to assist in monitoring and interacting with a dog. Your input is a short audio clip. Your task is to detect any barking in the audio, assess the dog's stress level, and generate a suitable action plan from the available options.

Tasks:

1) Describe Audio:
Analyze the provided audio clip and generate a short audio description of the sounds, if there are people talking then transcribe what has been said

2) Detect Barking:
Analyze the provided audio clip for any instances of barking.

3) Evaluate Stress Level:
Consider the frequency and intensity of barking to evaluate the dog's current stress level.

4) Generate Actions:
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
- an audio description string field
- a barking boolean field, if barking has been detected
- a stress level string field
- a list of actions to be taken to help alleviate the dog's stress with the following format:
  - each action in the list must contain an action field identifying the action to be taken, an optional id field identifying the id of the audio or toy and an optional message field with a generated message when appropriate
  
Example Output:
{
  "audioDescription": "a big dog barking loudly"
  "barking": true,
  "stressLevel": "high",
  "actions": [
    {"action": "action_1", "id": "audio_3"},
    {"action": "action_3"},
    {"action": "action_4", "id": "toy_1"},
    {"action": "action_5", "message": "Dog seems a bit restless. Please check the camera and see if they need anything."}
  ]
}  
""";

  GeminiBarkbuddyAiService();

  @override
  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom({
    required Uint8List audio,
    required String apiKey,
  }) async {
    var generativeModel = GenerativeModel(model: model, apiKey: apiKey);

    final prompt = [
      Content.multi([
        TextPart(systemPrompt),
        DataPart('audio/wav', Pcmtowave.pcmToWav(audio, 44100, 1))
      ])
    ];

    GenerateContentResponse generateContentResponse =
        await generativeModel.generateContent(prompt,
            generationConfig:
                GenerationConfig(responseMimeType: "application/json"));

    if (generateContentResponse.text != null) {
      logger.info("Computer says: ${generateContentResponse.text}");
      return BarkbuddyAiResponse.fromJsonString(generateContentResponse.text!);
    } else {
      logger.warn("Computer says no :(");
      return BarkbuddyAiResponse(
          barking: false,
          stressLevel: "none",
          audioDescription: "audio processing error");
    }
  }
}
