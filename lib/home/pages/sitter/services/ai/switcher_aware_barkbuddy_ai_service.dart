import 'dart:typed_data';

import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/gemini_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/stub_barkbuddy_ai_service.dart';

class SwitcherAwareBarkbuddyAiService implements BarkbuddyAiService {
  static final logger = Logger(name: (SwitcherAwareBarkbuddyAiService).toString());

  final GeminiBarkbuddyAiService geminiBarkbuddyAiService;
  final StubBarkbuddyAiService stubBarkbuddyAiService;
  final ServicesService servicesService;

  SwitcherAwareBarkbuddyAiService({
    required this.geminiBarkbuddyAiService,
    required this.stubBarkbuddyAiService,
    required this.servicesService,
  });

  @override
  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom(
      {required Uint8List audio}) async {
    var barkbuddyAiService = await instance;
    return await barkbuddyAiService.detectBarkingAndInferActionsFrom(audio: audio);
  }

  Future<BarkbuddyAiService> get instance async {
    try {
      var geminiUserService = await servicesService.getGeminiUserService();

      if (geminiUserService != null && geminiUserService.enabled) {
        return geminiBarkbuddyAiService;
      }
    } catch (error) {
      logger.warn("Error getting user services, will fallback to stub ai service, error was: $error");
    }
    return stubBarkbuddyAiService;
  }
}
