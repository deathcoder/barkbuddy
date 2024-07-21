import 'package:barkbuddy/home/navigation/animations/animations.dart';
import 'package:barkbuddy/home/navigation/bottombar/disappearing_bottom_navigation_bar.dart';
import 'package:barkbuddy/home/navigation/rail/disappearing_navigation_rail.dart';
import 'package:flutter/material.dart';

class NavigationScaffold extends StatefulWidget {
  final ValueChanged<int>? onDestinationSelected;
  final Widget body;
  final int selectedIndex;

  const NavigationScaffold({super.key, required this.body, required this.selectedIndex, this.onDestinationSelected,});

  @override
  State<NavigationScaffold> createState() => _NavigationScaffoldState();
}

class _NavigationScaffoldState extends State<NavigationScaffold> with SingleTickerProviderStateMixin {
  late final colorScheme = Theme.of(context).colorScheme;
  late final backgroundColor = Color.alphaBlend(colorScheme.primary.withOpacity(0.14), colorScheme.surface);

  late final controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);

  late final railAnimation = RailAnimation(parent: controller);
  late final barAnimation = BarAnimation(parent: controller);


  bool controllerInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    if (width > 600) {
      if (status != AnimationStatus.forward && status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse && status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > 600 ? 1 : 0;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return Scaffold(
            body: Row(
              children: [
                DisappearingNavigationRail(
                  railAnimation: railAnimation,
                  selectedIndex: widget.selectedIndex,
                  backgroundColor: backgroundColor,
                  onDestinationSelected: widget.onDestinationSelected,
                ),
                Expanded(
                  child: widget.body,
                ),
              ],
            ),
            bottomNavigationBar: DisappearingBottomNavigationBar(
              barAnimation: barAnimation,
              selectedIndex: widget.selectedIndex,
              onDestinationSelected: widget.onDestinationSelected,
            ),
          );
        });
  }
}
