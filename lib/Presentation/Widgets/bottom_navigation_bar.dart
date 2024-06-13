import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CBottomNavigation extends StatefulWidget {
  const CBottomNavigation({
    super.key,
    required this.currentTab,
    required this.changeTab,
  });

  final int currentTab;
  final void Function(int value)? changeTab;

  @override
  State<CBottomNavigation> createState() => _CBottomNavigationState();
}

class _CBottomNavigationState extends State<CBottomNavigation> {
  int currentPageIndex = 0;
  // late final AppLocalizations? tr = AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      elevation: 25,
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      onDestinationSelected: widget.changeTab,
      selectedIndex: widget.currentTab,

      // labelBehavior: NavigationDestinationLabelBehavior,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        // NavigationDestination(
        //   tooltip: "Dp Maker",
        //   selectedIcon: Icon(
        //     Icons.image_rounded,
        //     color: Colors.black,
        //   ),
        //   icon: Icon(
        //     Icons.image_rounded,
        //     size: 30,
        //   ),
        //   label: "Dp Maker",
        // ),
        NavigationDestination(
          tooltip: "Create Post",
          selectedIcon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          icon: Icon(Icons.add, size: 30),
          label: "Create",
        ),
        NavigationDestination(
          tooltip: "Leaderboard",
          selectedIcon: Icon(
            Icons.leaderboard,
            color: Colors.black,
          ),
          icon: Icon(Icons.leaderboard_outlined, size: 30),
          label: "Leaderboard",
        ),
        NavigationDestination(
          selectedIcon:
              Icon(Icons.account_circle_outlined, color: Colors.black),
          icon: Icon(
            Icons.widgets,
          ),
          label: "Menu",
        ),
      ],
    );
  }
}
