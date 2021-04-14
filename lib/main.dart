import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';
import 'common/utils/device_utils.dart';
import 'provider/api_provider.dart';
import 'provider/auth_provider.dart';
import 'provider/intl_provider.dart';
import 'provider/theme_provider.dart';

final _notificationsPlugin = FlutterLocalNotificationsPlugin();

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
    // init firebase
    await Firebase.initializeApp();
    // init workmanager
    // Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

    // initialise local notification plugin
    var androidInitialize = AndroidInitializationSettings('app_icon');
    // iOS permission request
    var iosInitialize = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    await _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      if (payload != null) {
        debugPrint('Notification payload:' + payload);
      }
    });

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

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) => Future.value(true));
}
