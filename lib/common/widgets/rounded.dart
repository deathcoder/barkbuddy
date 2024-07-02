import 'package:flutter/material.dart';

class Rounded extends StatelessWidget {
  final Widget image;
  final double circularRadius;

  const Rounded({super.key, required this.image, required this.circularRadius,});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(circularRadius),
      child: image,
    );
  }

  static Rounded circle({required Widget image}) {
    return Rounded(image: image, circularRadius: 50);
  }
}
