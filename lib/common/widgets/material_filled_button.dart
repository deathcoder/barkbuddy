import 'package:flutter/material.dart';

class MaterialFilledButton extends StatelessWidget {
  const MaterialFilledButton({super.key, this.onPressed, this.icon, required this.label, this.height=40});

  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 24.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            //children: <Widget>[icon,  const SizedBox(width: 8), label],
            children: <Widget>[label],
          ),
        ),
      ),
    );
  }
}
