import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

import 'explore/explore_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/double_back_exit_app.dart';
import 'widgets/fab.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final picker = ImagePicker();
  final _pageController = PageController();
  // default selected
  int _currentIndex = 0;

  // screen list for navigation bar
  var _screens = [
    HomeScreen(),
    ExploreScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void _onTap(int index) async {
    if (index == 2) {
      return null;
    }

    final newIndex = index > 2 ? index - 1 : index;
    // for ignore index == 2
    if (newIndex == null) {
      return;
    } else {
      setState(() {
        _currentIndex = newIndex;
      });
    }
    _pageController.jumpToPage(newIndex);

    //震動反饋
    if (!Device.isDesktop && await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 10); //0.1s
    }
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // press back button twice to exit app
    return DoubleBackExitApp(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          // 防止浮動按鈕隨鍵盤彈起上移
          resizeToAvoidBottomInset: false,
          floatingActionButton: FAB(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavBar(
            index: _currentIndex,
            onTap: _onTap,
          ),

          /// 使用 PageView 原因參看 https://zhuanlan.zhihu.com/p/58582876
          body: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: _screens,
            // 禁左右滑動切換頁
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
