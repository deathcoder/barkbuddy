import 'package:barkbuddy/common/widgets/barkbuddy_icons.dart';
import 'package:barkbuddy/home/pages/services/services_page.dart';
import 'package:barkbuddy/home/pages/sitter/sitter_page.dart';
import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label, {required this.builder});
  final IconData icon;
  final String label;
  final WidgetBuilder builder;
}

List<Destination> destinations = <Destination>[
  Destination(BarkbuddyIcons.dog, 'Sitter', builder: (_) => const SitterPage()),
  Destination(Icons.settings, 'Settings', builder: (_) => const ServicesPage()),
];