import 'package:barkbuddy/common/widgets/barkbuddy_icons.dart';
import 'package:barkbuddy/home/pages/devices/devices_page.dart';
import 'package:barkbuddy/home/pages/home_page.dart';
import 'package:barkbuddy/home/pages/settings_page.dart';
import 'package:barkbuddy/home/pages/sitter/ai_sitter_page.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label, {required this.builder});
  final IconData icon;
  final String label;
  final WidgetBuilder builder;
}

List<Destination> destinations = <Destination>[
  Destination(Icons.home_filled, 'Home', builder: (_) => const HomePage()),
  Destination(BarkbuddyIcons.dog, 'Sitter', builder: (_) => const AiSitterPage()),
  Destination(Icons.devices, 'Devices', builder: (_) => const DevicesPage()),
  Destination(Icons.settings, 'Settings', builder: (_) => const SettingsPage()),
];