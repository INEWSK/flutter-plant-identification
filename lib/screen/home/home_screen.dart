import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/api_provider.dart';
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
        Consumer<ApiProvider>(
          builder: (_, api, __) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Tree Doctor',
                  style: GoogleFonts.balooPaaji(
                    textStyle:
                        TextStyle(color: Color(0xFF0A8270), fontSize: 26.0),
                  ),
                ),
                actions: [
                  api.training
                      ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SpinKitFadingGrid(
                            color: Colors.teal,
                            size: 24,
                          ),
                        )
                      : Container()
                ],
              ),
              body: _body(),
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor.withAlpha(155),
            );
          },
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
        case Status.Network:
          return InfoApiList();
          break;
        case Status.Hive:
          return InfoApiList();
        default:
          // 初始化 hive
          // home.initInfoBox().then((_) {
          home.fetchApiData().then((success) {
            if (!success) {
              if (home.status == Status.Hive) {
                Toast.error(
                  title: '呼叫 API 失敗',
                  subtitle: '加載本地數據',
                );
              } else {
                Toast.error(
                  title: 'API 呼叫失敗, 本地沒有數據',
                  subtitle: '加載 DEMO',
                );
              }
            }
          });
          // });
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
