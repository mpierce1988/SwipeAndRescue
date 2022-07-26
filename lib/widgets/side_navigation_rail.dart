import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserSideNavigationRail extends StatefulWidget {
  int currentIndex;
  PageController pageController;
  UserSideNavigationRail(
      {Key? key, required this.currentIndex, required this.pageController})
      : super(key: key);

  @override
  State<UserSideNavigationRail> createState() => _UserSideNavigationRailState();
}

class _UserSideNavigationRailState extends State<UserSideNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.currentIndex,
      onDestinationSelected: (int index) {
        setState(
          () {
            widget.currentIndex = index;
            widget.pageController.jumpToPage(index);
          },
        );
      },
      destinations: <NavigationRailDestination>[
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.house), 'Home', context),
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.heart), 'Favourites', context),
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.user), 'Profile', context),
      ],
    );
  }
}

class AdminSideNavigationRail extends StatefulWidget {
  int currentIndex;
  PageController pageController;
  AdminSideNavigationRail(
      {Key? key, required this.currentIndex, required this.pageController})
      : super(key: key);

  @override
  State<AdminSideNavigationRail> createState() =>
      AdminSideNavigationRailState();
}

class AdminSideNavigationRailState extends State<AdminSideNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.currentIndex,
      onDestinationSelected: (int index) {
        setState(
          () {
            widget.pageController.jumpToPage(index);
            widget.currentIndex = index;
          },
        );
      },
      destinations: <NavigationRailDestination>[
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.house), 'Home', context),
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.heart), 'Favourites', context),
        _getNavigationRailDestination(
            const Icon(FontAwesomeIcons.user), 'Profile', context),
        _getNavigationRailDestination(
            const Icon(Icons.admin_panel_settings), 'Admin', context),
      ],
    );
  }
}

NavigationRailDestination _getNavigationRailDestination(
    Icon icon, String label, BuildContext context) {
  return NavigationRailDestination(
    icon: icon,
    selectedIcon: Icon(
      icon.icon,
      color: Theme.of(context).primaryColor,
    ),
    label: Text(label),
  );
}
