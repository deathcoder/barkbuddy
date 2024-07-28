import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
import 'package:just_audio/just_audio.dart';

class StubTtsService implements TextToSpeechService {
  @override
  Future<AudioPlayer> synthesize({
    required String message,
    required String accessToken,
    required String projectId,
  }) async {
    return AudioPlayer()..setAsset(Assets.goodBoyAudioStub);
  }

}
