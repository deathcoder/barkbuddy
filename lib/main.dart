import 'package:barkbuddy/app.dart';
import 'package:barkbuddy/common/settings.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/gemini_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/stub_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/recorder/audio_recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/stub_recorder_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.INFO;
  runApp(MultiProvider(providers: [
    Provider<RecorderService>(create: (context) => Settings.stub ? StubRecorderService() : AudioRecorderService()),
    Provider<BarkbuddyAiService>(
        create: (context) => Settings.stub ? StubBarkbuddyAiService() : GeminiBarkbuddyAiService(apiKey: "apiKey")),
  ], child: const App()));
}
