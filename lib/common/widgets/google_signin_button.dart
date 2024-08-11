import 'package:barkbuddy/common/assets.dart';
import 'package:barkbuddy/common/widgets/barkbuddy_fonts.dart';
import 'package:barkbuddy/common/widgets/material_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class GoogleSigninButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const GoogleSigninButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialOutlinedButton(
        // todo icon: const SvgPicture(AssetBytesLoader(Assets.googleLogoVec)),
        icon: SvgPicture.asset(Assets.googleLogo),
        label: const Text("Continue with Google", style: TextStyle(
          color: Color(0xFFE3E3E3),
          fontFamily: BarkbuddyFonts.robotoMedium
        ),),
        style: ButtonStyle(
          side: WidgetStateProperty.resolveWith<BorderSide?>(
                (Set<WidgetState> states) {
              return const BorderSide(
                  color: Color(0xFF8E918F),
              );
            },
          ),
          surfaceTintColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              return const Color(0xFF262626);
            },
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return const Color(0xFF262626);
              }
              if (states.contains(WidgetState.hovered)) {
                return const Color(0xFF262626);
              }
              return const Color(0xFF131314);
            },
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        onPressed: onPressed);
  }


}
