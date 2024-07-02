import 'package:flutter/material.dart';

import 'assets.dart';
import 'widgets/rounded.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.barkBuddyLogo,);
  }

  static Widget small() {
    return Rounded.circle(image: Container(color: Colors.white, height: 100, width: 100, child: const Logo()));
  }

  static Widget medium() {
    return Rounded.circle(image: Container(color: Colors.white, height: 250, width: 250, child: const Logo()));
  }
}
