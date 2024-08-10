import 'package:barkbuddy/home/navigation/destination.dart';
import 'package:barkbuddy/home/navigation/navigation_scaffold.dart';
import 'package:barkbuddy/home/pages/devices/bloc/devices_bloc.dart';
import 'package:barkbuddy/home/pages/devices/managers/devices_manager.dart';
import 'package:barkbuddy/home/pages/devices/services/devices_service.dart';
import 'package:barkbuddy/home/pages/services/services/services_service.dart';
import 'package:barkbuddy/home/pages/sitter/managers/barkbuddy_ai_manager.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/gemini_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/stub_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/ai/switcher_aware_barkbuddy_ai_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/notification/notification_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/google_tts_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/stub_tts_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/switcher_aware_tts_service.dart';
import 'package:barkbuddy/home/pages/sitter/services/tts/text_to_speech_service.dart';
import 'package:barkbuddy/login/services/users/barkbuddy_user_service.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'pages/services/bloc/services_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ServicesService>(
            create: (context) => ServicesService(
                userService: context.read<BarkbuddyUserService>())),
        Provider<DevicesService>(
            create: (context) => DevicesService(
                userService: context.read<BarkbuddyUserService>())),
        Provider<BarkbuddyAiService>(
          create: (context) => SwitcherAwareBarkbuddyAiService(
            geminiBarkbuddyAiService: GeminiBarkbuddyAiService(),
            stubBarkbuddyAiService: StubBarkbuddyAiService(),
            servicesService: context.read<ServicesService>(),
          ),
        ),
        Provider<BarkbuddyAiManager>(
            create: (context) => BarkbuddyAiManager(
                  servicesService: context.read<ServicesService>(),
                  barkbuddyAiService: context.read<BarkbuddyAiService>(),
                )),
        Provider<TextToSpeechService>(
          create: (context) => SwitcherAwareTtsService(
            googleTtsService: GoogleTtsService(),
            stubTtsService: StubTtsService(),
            servicesService: context.read<ServicesService>(),
          ),
        ),
        Provider<DevicesManager>(
            create: (context) => DevicesManager(
                  devicesService: context.read<DevicesService>(),
                  notificationService: context.read<NotificationService>(),
                )),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DevicesBloc>(
            create: (context) => DevicesBloc(
                devicesService: context.read<DevicesService>(),
                devicesManager: context.read<DevicesManager>())
              ..add(const InitializeDevices()),
          ),
          BlocProvider<ServicesBloc>(
            create: (context) => ServicesBloc(
              servicesService: context.read<ServicesService>(),
              barkbuddyUserService: context.read<BarkbuddyUserService>(),
            )..add(InitializeServices()),
          ),
        ],
        child: NavigationScaffold(
          selectedIndex: selectedIndex,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Center(child: destinations[selectedIndex].builder(context)),
            ),
          ),
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }

  void onDestinationSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
