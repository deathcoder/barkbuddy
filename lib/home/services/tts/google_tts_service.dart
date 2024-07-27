import 'dart:convert';

import 'package:barkbuddy/home/services/tts/source.dart';
import 'package:barkbuddy/home/services/tts/text_to_speech_service.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

class GoogleTtsService implements TextToSpeechService {
  static const String baseUrl = 'https://texttospeech.googleapis.com/v1/text:synthesize';

  final String projectId;

  GoogleTtsService({required this.projectId});

  Future<String> _getAccessToken() async {
    // TODO This is a placeholder. You'll need to implement a secure way to get the access token.
    // Consider using a backend service or a secure storage solution.
    return 'YOUR_ACCESS_TOKEN_HERE';
  }

  @override
  Future<AudioPlayer> synthesize({required String message}) async {
    final accessToken = await _getAccessToken();

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'x-goog-user-project': projectId,
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'input': {'text': message},
        'voice': {'languageCode': 'en-US', 'name': 'en-US-Journey-F'},
        'audioConfig': {
          'audioEncoding': 'MP3',
          'effectsProfileId': ['small-bluetooth-speaker-class-device'],
          'pitch': 0,
          'speakingRate': 1,
        },
      }),
    );

    if (response.statusCode == 200) {
      final audioContent = jsonDecode(response.body)['audioContent'] as String;
      final audioBytes = base64.decode(audioContent);

      // Play the audio using just_audio
      final player = AudioPlayer();
      await player.setAudioSource(MP3StreamAudioSource(audioBytes));
      return player;
    } else {
      throw Exception('Failed to synthesize speech: ${response.statusCode}');
    }
  }
}
