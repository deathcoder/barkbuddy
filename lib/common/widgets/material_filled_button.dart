import 'package:barkbuddy/common/widgets/horizontal_space.dart';
import 'package:flutter/material.dart';

class MaterialFilledButton extends StatelessWidget {
  const MaterialFilledButton(
      {super.key,
      this.onPressed,
      this.icon,
      required this.label,
      this.height = 40});

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
            children: <Widget>[
              if (icon != null) icon!,
              if (icon != null) HorizontalSpace.small(),
              label,
            ],
          ),
        ),
      ),
    );
  }
}
