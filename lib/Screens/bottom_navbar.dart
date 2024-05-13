import 'package:chat_app_with_backend/Screens/AuthScreen/login_screen.dart';
import 'package:chat_app_with_backend/Screens/HomeScreen/home_screen.dart';
import 'package:chat_app_with_backend/Screens/SearchScreen/search_screen.dart';
import 'package:chat_app_with_backend/Screens/Setting_screen.dart';
import 'package:chat_app_with_backend/Screens/User%20Profile/user_profile.dart';
import 'package:chat_app_with_backend/Socket%20connection/socket.dart';
import 'package:chat_app_with_backend/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    Socket.socket.connect();
    super.initState();
  }

  void _handleLogout(BuildContext context) async {
    await Utils.removeToken();
    await Utils.removeUser();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  List<Widget> _buildScreens(BuildContext context) {
    return [
      HomeScreen(
        context: context,
      ),
      SearchScreen(),
    
      const SettingScreen(),
      UserProfile(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(
      BuildContext context, void Function(BuildContext) logoutCallback) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.house_fill,
        ),
        activeColorPrimary: Colors.purpleAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.search),
        activeColorPrimary: Colors.purpleAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
   
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.bell_fill),
        activeColorPrimary: Colors.purpleAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.person),
        activeColorPrimary: Colors.purpleAccent,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  void dispose() {
    Socket.socket.disconnect();
    Socket.socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarHeight: 60,
      context,
      controller: _controller,
      screens: _buildScreens(context),
      items: _navBarsItems(context, _handleLogout),
      confineInSafeArea: true,
      backgroundColor: Colors.black, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.

      stateManagement: true, // Default is true.

      decoration: const NavBarDecoration(
        colorBehindNavBar: Colors.black,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style13, // Choose the nav bar style with this property.
    );
  }
}
