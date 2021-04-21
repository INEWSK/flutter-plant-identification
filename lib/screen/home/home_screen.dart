import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/home/components/home_background.dart';
import 'package:flutter_hotelapp/screen/home/components/info_api_list.dart';
import 'package:flutter_hotelapp/screen/home/components/info_demo_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'provider/home_provider.dart';

/// 使用 AutomaticKeepAliveClientMixin，並重寫 wantKeepAlive 方法，讓狀態不被回收掉
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        HomeBackground(),
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Tree Doctor',
              style: GoogleFonts.balooPaaji(
                textStyle: TextStyle(color: Colors.green, fontSize: 26.0),
              ),
            ),
          ),
          body: _body(),
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withAlpha(155),
        ),
      ],
    );
  }

  Widget _body() {
    return Consumer<HomeProvider>(builder: (_, home, __) {
      switch (home.status) {
        case Status.Error:
          return InfoDemoList();
          break;
        case Status.Loaded:
          return InfoApiList();
          break;
        default:
          home.fetchData();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitFadingCube(color: Colors.teal),
            ],
          );
      }
    });
  }
}
