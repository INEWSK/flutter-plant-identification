import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/provider/api_provider.dart';
import 'package:flutter_hotelapp/screen/common_widgets/bottom_tab_bar.dart';
import 'package:flutter_hotelapp/screen/home/provider/home_provider.dart';
import 'package:flutter_hotelapp/screen/search/provider/search_provider.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'common_widgets/double_back_exit_app.dart';
import 'common_widgets/speed_dial.dart';
import 'explore/explore_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final picker = ImagePicker();
  final _pageController = PageController();
  // default selected
  int _currentIndex = 0;

  AnimationController _controller;

  // screen list for navigation bar
  var _screens = [
    HomeScreen(),
    ExploreScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  final homeScreen = ChangeNotifierProvider(
    create: (BuildContext context) => HomeProvider(),
  );
  final searchScreen = ChangeNotifierProvider(
    create: (BuildContext context) => SearchProvider(),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kDefaultDuration * 0.5,
    );
    _checkTaskStatus();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _controller?.dispose();
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

    //????????????
    // if (Device.isMobile && await Vibration.hasVibrator()) {
    //   Vibration.vibrate(duration: 10); //0.1s
    // }
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // press back button twice to exit app
    return MultiProvider(
      providers: [homeScreen, searchScreen],
      child: DoubleBackExitApp(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            // ???????????????????????????????????????
            resizeToAvoidBottomInset: false,
            floatingActionButton: SpeedDial(
              controller: _controller,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomTabBar(
              index: _currentIndex,
              onTap: _onTap,
            ),

            /// ?????? PageView ???????????? https://zhuanlan.zhihu.com/p/58582876
            body: PageView(
              controller: _pageController,
              onPageChanged: onPageChanged,
              children: _screens,
              // ????????????????????????
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ),
      ),
    );
  }

  /// ???????????????????????? model retraining task ????????????
  void _checkTaskStatus() async {
    var box = Hive.box(Constant.box);
    if (box.get(Constant.taskId) != null) {
      context.read<ApiProvider>().browseTaskStatus();
    }
  }
}
