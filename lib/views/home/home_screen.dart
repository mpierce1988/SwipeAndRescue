import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/views/home/admin_page.dart';
import 'package:swipeandrescue/views/home/browse_animals_page.dart';
import 'package:swipeandrescue/views/home/favourites_page.dart';
import 'package:swipeandrescue/views/home/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  final Duration _animatePageDuration = const Duration(milliseconds: 500);

  final Curve _animatePageCurve = Curves.easeOutQuad;

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    bool isShelterAdmin = _isShelterAdmin(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: isShelterAdmin ? _shelterAdminPageView() : _userPageView(),
      bottomNavigationBar: isShelterAdmin
          ? _shelterWorkerBottomNavigationBar()
          : _userBottomNavigationBar(),
    );
  }

  PageView _userPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        BrowseAnimalsPage(),
        const FavouritesPage(),
        const ProfilePage(),
      ],
    );
  }

  PageView _shelterAdminPageView() {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        BrowseAnimalsPage(),
        const FavouritesPage(),
        const ProfilePage(),
        const AdminPage(),
      ],
    );
  }

  BottomNavigationBar _userBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentPageIndex,
      onTap: (value) {
        _currentPageIndex = value.toInt();
        _pageController.animateToPage(value,
            duration: _animatePageDuration, curve: _animatePageCurve);
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

  BottomNavigationBar _shelterWorkerBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentPageIndex,
      onTap: (value) {
        _currentPageIndex = value.toInt();
        _pageController.animateToPage(value,
            duration: _animatePageDuration, curve: _animatePageCurve);
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

  bool _isShelterAdmin(BuildContext context) {
    // determines if the current user is a shelter worker/admin
    AppUser appUser = Provider.of<AuthenticateController>(context).appUser;

    if (appUser.shelter == null) {
      return false;
    }
    if (appUser.shelter!.shelterId.isEmpty ||
        appUser.shelter!.shelterId == '') {
      return false;
    }

    return true;
  }
}
