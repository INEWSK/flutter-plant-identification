import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';

import 'app.dart';
import 'common/utils/device_utils.dart';
import 'provider/api_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/intl_provider.dart';
import 'provider/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// prevent device orientation changes and force portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    // init data store
    await Hive.initFlutter();
    // init sp
    await SpUtil.getInstance();

    /// init provider
    final authProvider = ChangeNotifierProvider(
      create: (_) => AuthProvider(),
    );
    final themeProvider = ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
    );
    final intlProvider = ChangeNotifierProvider(
      create: (_) => IntlProvider(),
    );
    final apiProvider = ChangeNotifierProvider(
      create: (_) => ApiProvider(),
    );

    runApp(
      MultiProvider(
        providers: [
          authProvider, // 管理用戶狀態
          themeProvider, // 管理APP主題界面
          intlProvider, // 管理APP語言
          apiProvider, // API CALL
        ],
        child: MyApp(),
      ),
    );

    /// transparent android status bar
    if (Device.isAndroid) {
      const SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  });
}
