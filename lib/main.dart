import 'package:barkbuddy/app.dart';
import 'package:barkbuddy/common/log/logger.dart';
import 'package:barkbuddy/common/settings.dart';
import 'package:barkbuddy/firebase_options.dart';
import 'package:barkbuddy/home/bloc/audio_recorder_bloc.dart';
import 'package:barkbuddy/home/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/gemini_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/ai/stub_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/services/notification/firebase_notification_service.dart';
import 'package:barkbuddy/home/services/notification/local_notification_service.dart';
import 'package:barkbuddy/home/services/notification/notification_service.dart';
import 'package:barkbuddy/home/services/recorder/audio_recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/recorder_service.dart';
import 'package:barkbuddy/home/services/recorder/stub_recorder_service.dart';
import 'package:barkbuddy/home/services/tts/google_tts_service.dart';
import 'package:barkbuddy/home/services/tts/stub_tts_service.dart';
import 'package:barkbuddy/home/services/tts/text_to_speech_service.dart';
import 'package:barkbuddy/login/services/auth/authentication_service.dart';
import 'package:barkbuddy/login/services/users/user_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart' hide Logger;
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const SimpleBlocObserver();
  Logger.rootLevel = Level.INFO;

  FirebaseOptions options = DefaultFirebaseOptions.currentPlatform;
  await Firebase.initializeApp(
    options: options,
  );

  await FirebaseAppCheck.instance.activate(
    // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
    // argument for `webProvider`
    webProvider: ReCaptchaV3Provider('6LdBCBoqAAAAAM-faNvDHiyBEk5eX5smnYhUkB0L'),
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug, // todo debug should only be used in debug mode
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.debug, // todo debug should only be used in debug mode
  );
  runApp(MultiProvider(providers: [
    Provider<RecorderService>(
      create: (context) => Settings.stub.audio ? StubRecorderService() : AudioRecorderService(),
      dispose: (context, value) async => await value.dispose(),
    ),
    Provider<BarkbuddyAiService>(
      // todo rotate leaked api key
        create: (context) => Settings.stub.gemini ? StubBarkbuddyAiService() : GeminiBarkbuddyAiService(apiKey: "AIzaSyAw364EonJRQC7GteimpNJgiUr_dM8HOwM "),
    ),
    Provider<NotificationService>(
      create: (context) => Settings.stub.notifications || kIsWeb ? LocalNotificationService() : FirebaseNotificationService(),
    ),
    Provider<TextToSpeechService>(
      create: (context) => Settings.stub.textToSpeech ? StubTtsService() : GoogleTtsService(projectId: 'chatterbox-73d26'),
    ),
    Provider<AuthenticationService>(create: (context) => AuthenticationService()),
    Provider<UserService>(create: (context) => UserService()),
  ], child: const App()));
}

class SimpleBlocObserver extends BlocObserver {
  static final logger = Logger(name: (SimpleBlocObserver).toString());

  const SimpleBlocObserver();

  @override
  void onTransition(
      Bloc<dynamic, dynamic> bloc,
      Transition<dynamic, dynamic> transition,
      ) {
    super.onTransition(bloc, transition);
    switch (transition.nextState) {
      case AudioRecorderState(logDebugTransition: var logDebugTransition) when logDebugTransition:
        logger.debug(transition.toString());
      default:
        logger.info(transition.toString());
    }
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    logger.error(error.toString());
    super.onError(bloc, error, stackTrace);
  }
}