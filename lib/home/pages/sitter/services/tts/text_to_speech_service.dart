import 'package:just_audio/just_audio.dart';

abstract interface class TextToSpeechService {
  Future<AudioPlayer> synthesize({
    required String message,
    required String accessToken,
    required String projectId,
  });
}