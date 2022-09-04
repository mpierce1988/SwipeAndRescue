import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/constants.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/views/home/admin_page.dart';
import 'package:swipeandrescue/views/home/browse_animals_page.dart';
import 'package:swipeandrescue/views/home/favourites_page.dart';
import 'package:swipeandrescue/views/home/profile_page.dart';
import 'package:swipeandrescue/widgets/bottom_navigation_bar.dart';
import 'package:swipeandrescue/widgets/side_navigation_rail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  final Duration _animatePageDuration = const Duration(milliseconds: 500);

  final Curve _animatePageCurve = Curves.easeOutQuad;

  final int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppUser appUser = Provider.of<AuthenticateController>(context).appUser;
    bool isShelterAdmin = _isShelterAdmin(appUser);

    debugPrint('Home screen is (re)building...');

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= Constants().mediumWidth) {
          // small layout
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body:
                isShelterAdmin ? _shelterAdminPageViewSm() : _userPageViewSm(),
            bottomNavigationBar: isShelterAdmin
                ? ShelterWorkerBottomNavigationBar(
                    currentPageindex: _currentPageIndex,
                    pageController: _pageController,
                    animatePageDuration: _animatePageDuration,
                    animatePageCurve: _animatePageCurve,
                  )
                : UserBottomNavigationBar(
                    currentPageindex: _currentPageIndex,
                    pageController: _pageController,
                    animatePageDuration: _animatePageDuration,
                    animagePageCurve: _animatePageCurve),
          );
        } else if (constraints.maxWidth <= Constants().largeWidth) {
          // medium layout
          return Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body:
                isShelterAdmin ? _shelterAdminPageViewSm() : _userPageViewSm(),
            bottomNavigationBar: isShelterAdmin
                ? ShelterWorkerBottomNavigationBar(
                    currentPageindex: _currentPageIndex,
                    pageController: _pageController,
                    animatePageDuration: _animatePageDuration,
                    animatePageCurve: _animatePageCurve)
                : UserBottomNavigationBar(
                    currentPageindex: _currentPageIndex,
                    pageController: _pageController,
                    animatePageDuration: _animatePageDuration,
                    animagePageCurve: _animatePageCurve),
          );
        }
        // large layout
        debugPrint('Using large layout...');
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: Row(
            children: [
              isShelterAdmin
                  ? AdminSideNavigationRail(
                      currentIndex: _currentPageIndex,
                      pageController: _pageController)
                  : UserSideNavigationRail(
                      currentIndex: _currentPageIndex,
                      pageController: _pageController),
              isShelterAdmin ? _shelterAdminPageViewLg() : _userPageViewLg(),
            ],
          ),
          // bottomNavigationBar: isShelterAdmin
          //     ? _shelterWorkerBottomNavigationBar()
          //     : _userBottomNavigationBar(),
        );
      },
    );
  }

// Page Views

  PageView _userPageViewSm() {
    FavouritesPage favouritesPage = FavouritesPage();
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        const BrowseAnimalsPage(),
        FavouritesPage(),
        const ProfilePage(),
      ],
      onPageChanged: (id) {
        if (id == 1) {
          // refresh favourites page
          favouritesPage.refresh();
        }
      },
    );
  }

  Widget _userPageViewLg() {
    FavouritesPage favouritesPage = FavouritesPage();
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const BrowseAnimalsPage(),
          FavouritesPage(),
          const ProfilePage(),
        ],
        onPageChanged: (id) {
          if (id == 1) {
            // refresh favourites page
            favouritesPage.refresh();
          }
        },
      ),
    );
  }

  PageView _shelterAdminPageViewSm() {
    FavouritesPage favouritesPage = FavouritesPage();
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        const BrowseAnimalsPage(),
        favouritesPage,
        const ProfilePage(),
        const AdminPage(),
      ],
      onPageChanged: (id) {
        if (id == 1) {
          // refresh favourites page
          favouritesPage.refresh();
        }
      },
    );
  }

  Widget _shelterAdminPageViewLg() {
    FavouritesPage favouritesPage = FavouritesPage();
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          const BrowseAnimalsPage(),
          FavouritesPage(),
          const ProfilePage(),
          const AdminPage(),
        ],
        onPageChanged: (id) {
          if (id == 1) {
            // refresh favourites page
            favouritesPage.refresh();
          }
        },
      ),
    );
  }

// Helper functions

  bool _isShelterAdmin(AppUser appUser) {
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
