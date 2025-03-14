import 'package:barkbuddy/common/widgets/horizontal_space.dart';
import 'package:flutter/material.dart';

class MaterialFilledButton extends StatelessWidget {
  const MaterialFilledButton({
    super.key,
    this.onPressed,
    this.icon,
    required this.label,
    this.padding = const EdgeInsets.only(left: 16.0, right: 24.0),
    this.height = 40,
    this.style,
  });

  final VoidCallback? onPressed;
  final Widget? icon;
  final Widget label;
  final double height;
  final EdgeInsets padding;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FilledButton(
        style: style,
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) icon!,
            if (icon != null) HorizontalSpace.small(),
            label,
          ],
        ),
      ),
    );
  }
}
