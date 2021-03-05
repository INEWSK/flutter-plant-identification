import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/screen/view_image/provider/view_image_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'common/utils/device_utils.dart';
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
    /// init data store
    await Hive.initFlutter();

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
    final imgProvider = ChangeNotifierProvider(
      create: (_) => ViewImageProvider(),
    );

    runApp(
      MultiProvider(
        providers: [
          authProvider,
          themeProvider,
          intlProvider,
          imgProvider,
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
