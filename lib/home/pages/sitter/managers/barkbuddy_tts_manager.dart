import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
import 'package:just_audio/just_audio.dart';

class BarkbuddyTtsManager {
  final ServicesService servicesService;
  final TextToSpeechService textToSpeechService;
  final bool demo;

  BarkbuddyTtsManager({
    required this.servicesService,
    required this.textToSpeechService,
    this.demo = false,
  });

  Future<AudioPlayer> synthesize({required String message}) async {
    var ttsService = await servicesService.getGoogleTtsUserService();
    if (ttsService == null && !demo) {
      throw "Please configure your Google TTS Service in the Services tab";
    }

    return await textToSpeechService.synthesize(
      message: message,
      accessToken: ttsService?.accessToken ?? "demo",
      projectId: ttsService?.projectId ?? "demo",
    );
  }
}
