import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserBottomNavigationBar extends StatefulWidget {
  int currentPageindex;
  PageController pageController;
  Duration animatePageDuration;
  Curve animagePageCurve;

  UserBottomNavigationBar(
      {Key? key,
      required this.currentPageindex,
      required this.pageController,
      required this.animatePageDuration,
      required this.animagePageCurve})
      : super(key: key);

  @override
  State<UserBottomNavigationBar> createState() =>
      _UserBottomNavigationBarState();
}

class _UserBottomNavigationBarState extends State<UserBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentPageindex,
      onTap: (value) {
        widget.currentPageindex = value.toInt();
        widget.pageController.animateToPage(value,
            duration: widget.animatePageDuration,
            curve: widget.animagePageCurve);
        setState(() {});
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heart), label: 'Favourites'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
      ],
    );
  }
}

class ShelterWorkerBottomNavigationBar extends StatefulWidget {
  int currentPageindex;
  PageController pageController;
  Duration animatePageDuration;
  Curve animatePageCurve;

  ShelterWorkerBottomNavigationBar(
      {Key? key,
      required this.currentPageindex,
      required this.pageController,
      required this.animatePageDuration,
      required this.animatePageCurve})
      : super(key: key);

  @override
  State<ShelterWorkerBottomNavigationBar> createState() =>
      _ShelterWorkerBottomNavigationBarState();
}

class _ShelterWorkerBottomNavigationBarState
    extends State<ShelterWorkerBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentPageindex,
      onTap: (value) {
        widget.currentPageindex = value.toInt();
        widget.pageController.animateToPage(value,
            duration: widget.animatePageDuration,
            curve: widget.animatePageCurve);
        setState(() {});
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heart), label: 'Favourites'),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
        BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
      ],
    );
  }
}
