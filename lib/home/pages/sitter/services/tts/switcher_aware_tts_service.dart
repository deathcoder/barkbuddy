import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/google_tts_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/stub_tts_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
import 'package:just_audio/just_audio.dart';

class SwitcherAwareTtsService implements TextToSpeechService {
  static final logger = Logger(name: (SwitcherAwareTtsService).toString());

  final GoogleTtsService googleTtsService;
  final StubTtsService stubTtsService;
  final ServicesService servicesService;

  SwitcherAwareTtsService({
    required this.googleTtsService,
    required this.stubTtsService,
    required this.servicesService,
  });

  @override
  Future<AudioPlayer> synthesize({
    required String message,
    required String accessToken,
    required String projectId,
  }) async {
    var textToSpeechService = await instance;
    return await textToSpeechService.synthesize(
      message: message,
      accessToken: accessToken,
      projectId: projectId,
    );
  }

  Future<TextToSpeechService> get instance async {
    try {
      var googleTtsUserService =
          await servicesService.getGoogleTtsUserService();

      if (googleTtsUserService != null && googleTtsUserService.enabled) {
        return googleTtsService;
      }
    } catch (error) {
      logger.warn(
          "Error getting user services, will fallback to stub tts service, error was: $error");
    }
    return stubTtsService;
  }
}
