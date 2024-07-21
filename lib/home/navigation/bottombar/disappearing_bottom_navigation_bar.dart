import 'package:barkbuddy/home/navigation/animations/animations.dart';
import 'package:barkbuddy/home/navigation/bottombar/bottom_bar_transition.dart';
import 'package:barkbuddy/home/navigation/destination.dart';
import 'package:flutter/material.dart';

class DisappearingBottomNavigationBar extends StatelessWidget {
  const DisappearingBottomNavigationBar({
    super.key,
    required this.barAnimation,
    required this.selectedIndex,
    this.onDestinationSelected,
  });

  final BarAnimation barAnimation;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    // Modify from here...
    return BottomBarTransition(
      animation: barAnimation,
      // backgroundColor: Colors.white,
      child: NavigationBar(
        elevation: 0,
        // backgroundColor: Colors.white,
        destinations: destinations.map<NavigationDestination>((d) {
          return NavigationDestination(
            icon: Icon(d.icon),
            label: d.label,
          );
        }).toList(),
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
      ),
    );
    // ... to here.
  }
}