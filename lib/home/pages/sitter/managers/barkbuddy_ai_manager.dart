import 'dart:typed_data';

import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';

class BarkbuddyAiManager {
  final ServicesService servicesService;
  final BarkbuddyAiService barkbuddyAiService;

  BarkbuddyAiManager({
    required this.servicesService,
    required this.barkbuddyAiService,
  });

  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom(
      {required Uint8List audio}) async {
    var geminiUserService = await servicesService.getGeminiUserService();
    if (geminiUserService == null) {
      throw "Please configure your Gemini Api Key in the Services tab";
    }

    return await barkbuddyAiService.detectBarkingAndInferActionsFrom(
      audio: audio,
      apiKey: geminiUserService.apiKey,
    );
  }
}
