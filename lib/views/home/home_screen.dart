import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:swipeandrescue/constants.dart';
import 'package:swipeandrescue/controllers/authenticate_controller.dart';
import 'package:swipeandrescue/models/app_user.dart';
import 'package:swipeandrescue/views/home/admin_page.dart';
import 'package:swipeandrescue/views/home/browse_animals_page.dart';
import 'package:swipeandrescue/views/home/favourites_page.dart';
import 'package:swipeandrescue/views/home/profile_page.dart';
import 'package:swipeandrescue/widgets/bottom_navigation_bar.dart';

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
              isShelterAdmin ? _shelterAdminSideRail() : _userSideRail(),
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

  PageView _userPageViewSm() {
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

  Widget _userPageViewLg() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          BrowseAnimalsPage(),
          const FavouritesPage(),
          const ProfilePage(),
        ],
      ),
    );
  }

  PageView _shelterAdminPageViewSm() {
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

  Widget _shelterAdminPageViewLg() {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          BrowseAnimalsPage(),
          const FavouritesPage(),
          const ProfilePage(),
          const AdminPage(),
        ],
      ),
    );
  }

  // BottomNavigationBar _shelterWorkerBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     type: BottomNavigationBarType.fixed,
  //     currentIndex: _currentPageIndex,
  //     onTap: (value) {
  //       _currentPageIndex = value.toInt();
  //       _pageController.animateToPage(value,
  //           duration: _animatePageDuration, curve: _animatePageCurve);
  //       setState(() {});
  //     },
  //     items: const [
  //       BottomNavigationBarItem(
  //           icon: Icon(FontAwesomeIcons.house), label: 'Home'),
  //       BottomNavigationBarItem(
  //           icon: Icon(FontAwesomeIcons.heart), label: 'Favourites'),
  //       BottomNavigationBarItem(
  //           icon: Icon(FontAwesomeIcons.user), label: 'Profile'),
  //       BottomNavigationBarItem(
  //           icon: Icon(Icons.admin_panel_settings), label: 'Admin'),
  //     ],
  //   );
  // }

  NavigationRail _userSideRail() {
    return NavigationRail(
      selectedIndex: _currentPageIndex,
      onDestinationSelected: (int index) {
        setState(
          () {
            _currentPageIndex = index;
            _pageController.animateToPage(index,
                duration: _animatePageDuration, curve: _animatePageCurve);
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

  NavigationRail _shelterAdminSideRail() {
    return NavigationRail(
      selectedIndex: _currentPageIndex,
      onDestinationSelected: (int index) {
        setState(
          () {
            _pageController.animateToPage(index,
                duration: _animatePageDuration, curve: _animatePageCurve);
            _currentPageIndex = index;
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
