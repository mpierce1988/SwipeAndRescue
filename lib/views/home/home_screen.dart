import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  final Curve _animatePageurve = Curves.easeOutQuad;

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          BrowseAnimalsPage(),
          const FavouritesPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (value) {
          _currentPageIndex = value.toInt();
          _pageController.animateToPage(value,
              duration: _animatePageDuration, curve: _animatePageurve);
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
      ),
    );
  }
}
