import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/main_screen.dart';
import 'package:flutter_hotelapp/screen/onboarding/onboarding_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import 'common/styles/styles.dart';
import 'common/themes/themes.dart';
import 'provider/auth_provider.dart';
import 'provider/intl_provider.dart';
import 'provider/theme_provider.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  final Widget home;
  final Theme theme;

  const MyApp({Key key, this.home, this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return OKToast(
      child: Consumer3(
        builder: (_, ThemeProvider themer, AuthProvider user,
            IntlProvider locale, __) {
          return MaterialApp(
            theme: theme ?? lightTheme,
            darkTheme: darkTheme,
            themeMode: themer.getThemeMode(),
            // 優雅地管理 route
            routes: Routes.routes,
            builder: (context, child) {
              /// 文字大小不受手機設定影響(不被强制放大)
              /// https://www.kikt.top/posts/flutter/layout/dynamic-text/
              child = MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child,
              );
              child = botToastBuilder(context, child);
              return child;
            },
            navigatorObservers: [BotToastNavigatorObserver()],
            home: home ??
                Builder(builder: (_) {
                  // did user see the introduction screen?
                  bool _seen = SpUtil.getBool('seen') ?? false;
                  if (user.status == Status.Uninitialized)
                    user.initAuthProvider();
                  if (_seen) {
                    return MainScreen();
                  } else {
                    return OnBoardingScreen();
                  }
                }),
          );
        },
      ),

      /// global OKToast widget style
      backgroundColor: Colors.black54,
      textPadding: kToastPadding,
      radius: 25.0,
      position: ToastPosition.bottom,
    );
  }
}
