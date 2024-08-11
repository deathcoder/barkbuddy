import 'package:flutter/material.dart';

import 'assets.dart';
import 'widgets/rounded.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.barkBuddyLogo,);
  }

  static Widget tiny({Color? backgroundColor = Colors.white}) {
    return Rounded.circle(image: Container(color: backgroundColor, width: 64, child: const Logo()));
  }

  static Widget small({Color? backgroundColor = Colors.white}) {
    return Rounded.circle(image: Container(color: backgroundColor, height: 100, width: 100, child: const Logo()));
  }

  static Widget medium({Color? backgroundColor = Colors.white}) {
    return Rounded.circle(image: Container(color: backgroundColor, height: 250, width: 250, child: const Logo()));
  }
}
