import 'package:barkbuddy/app.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.root.level = Level.INFO;
  runApp(const App());
}

