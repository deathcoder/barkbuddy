import 'package:barkbuddy/app.dart';
import 'package:barkbuddy/common/settings.dart';
import 'package:barkbuddy/firebase_options.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/gemini_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/stub_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/notification/firebase_notification_service.dart';
import 'package:barkbuddy/home/services/notification/local_notification_service.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:barkbuddy/home/services/recorder/audio_recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/stub_recorder_service.dart';
import 'package:barkbuddy/home/services/tts/stub_tts_service.dart';
import 'package:barkbuddy/home/services/tts/text_to_speech_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(
    options: options,
  );

  Logger.root.level = Level.INFO;
  runApp(MultiProvider(providers: [
    Provider<RecorderService>(
      create: (context) => Settings.stub ? StubRecorderService() : AudioRecorderService(),
      dispose: (context, value) async => await value.dispose(),
    ),
    Provider<BarkbuddyAiService>(
        create: (context) => Settings.stub ? StubBarkbuddyAiService() : GeminiBarkbuddyAiService(apiKey: "apiKey"),
    ),
    Provider<NotificationService>(
      create: (context) => Settings.stub ? LocalNotificationService() : FirebaseNotificationService(),
    ),
    Provider<TextToSpeechService>(
      create: (context) => StubTtsService(),
    ),
  ], child: const App()));
}
