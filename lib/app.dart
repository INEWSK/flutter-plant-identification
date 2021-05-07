import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:flutter_hotelapp/screen/main_screen.dart';
import 'package:flutter_hotelapp/screen/onboarding/onboarding_screen.dart';
import 'package:hive/hive.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var box = Hive.box(Constant.box);
    // box.clear();
    final botToastBuilder = BotToastInit();
    return OKToast(
      child: Consumer3(
        builder: (_, ThemeProvider themer, AuthProvider user,
            IntlProvider localer, __) {
          return MaterialApp(
            // debugShowCheckedModeBanner: false, // top-right debug flag
            theme: theme ?? lightTheme(context),
            darkTheme: darkTheme(context),
            themeMode: themer.getThemeMode(),
            // 在地化
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              //english, no country code
              const Locale('en', ''),
              //generic simplified Chinese 'zh_Hans'
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
              //generic traditional Chinese 'zh_Hant'
              const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
            ],
            locale: localer.locale,
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
                  if (user.status == Status.Uninitialized)
                    user.initAuthProvider();
                  bool seen = box.get(Constant.seen) ?? false;
                  if (seen) {
                    return MainScreen();
                  } else {
                    return OnBoardingScreen();
                  }
                }),
          );
        },
      ),

      /// global Toast widget style
      backgroundColor: Colors.black54,
      textPadding: kToastPadding,
      radius: 25.0,
      position: ToastPosition.bottom,
    );
  }
}
