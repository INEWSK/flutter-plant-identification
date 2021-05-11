import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  Timer _timer;

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _broswerTaskStatus(ApiProvider api) {
    // 如果 training 設置 timer 每 x 秒執行一次 method
    _timer = Timer.periodic(
      Duration(minutes: 1),
      (_) => api.browseTaskStatus().then(
        (result) async {
          final done = result['done'];
          final success = result['success'];
          if (done) {
            if (success) {
              Toast.notification(
                // icon: Icons.done,
                title: AppLocalizations.of(context).modelUpdated,
                subtitle: AppLocalizations.of(context).modelUpdatedText,
                duration: 15,
              );
            } else {
              Toast.error(
                title: AppLocalizations.of(context).modelUpdateFailed,
                subtitle: AppLocalizations.of(context).modelUpdateFailedText,
                duration: 15,
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        HomeBackground(),
        Consumer<ApiProvider>(
          builder: (_, api, __) {
            if (api.training == true) {
              _broswerTaskStatus(api);
            } else {
              // 反之則取消 timer
              _timer?.cancel();
            }
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
          home.fetchApiData().then((success) {
            if (!success) {
              if (home.status == Status.Hive) {
                Toast.error(
                  title: AppLocalizations.of(context).callApiFailed,
                  subtitle: AppLocalizations.of(context).loadLocalData,
                );
              } else {
                Toast.error(
                  title: AppLocalizations.of(context).noApiAndNoLocalData,
                  subtitle: AppLocalizations.of(context).loadDemoData,
                );
              }
            }
          });
          // loading widget
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
