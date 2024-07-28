import 'dart:typed_data';

import 'package:barkbuddy/home/models/barkbuddy_ai_response.dart';

abstract interface class BarkbuddyAiService {
  Future<BarkbuddyAiResponse> detectBarkingAndInferActionsFrom({
    required Uint8List audio,
    required String apiKey,
  });
}