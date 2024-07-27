import 'dart:developer' as developer;

import 'package:logging/logging.dart';

class Logger {
  static Level rootLevel = Level.INFO;
  
  final String name;

  Logger({required this.name});

  void error(String message) {
    log(message, level: Level.SEVERE);
  }

  void warn(String message) {
    log(message, level: Level.WARNING);
  }

  void debug(String message) {
    log(message, level: Level.FINE);
  }

  void info(String message) {
    log(message, level: Level.INFO);
  }

  void log(String message, {Level level = Level.INFO}) {
    if(level >= rootLevel) {
      developer.log(message, name: name, level: level.value);
    }
  }
}