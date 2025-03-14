import 'package:barkbuddy/login/login_screen.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bark Buddy',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.teal.shade700, // Deep Teal
          useMaterial3: true
      ),
      theme: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.teal.shade700, // Deep Teal
          useMaterial3: true
      ),
      navigatorKey: _navigatorKey,
      onGenerateRoute: (_) => LoginScreen.route(),
    );
  }
}