import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// TODO: get darkmode
extension ThemeModeExtension on ThemeMode {
  get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  // themeMode 不允許返回 future type, 暫時設置為系統跟隨
  var _themeMode = ThemeMode.system;
  // 用於返回 theme mode
  ThemeMode get themeMode => _themeMode;

  void syncTheme() async {
    var box = await Hive.openBox('themeBox');
    final String theme = box.get('theme');

    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  // 持久化主題設置
  void setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;

    var box = await Hive.openBox('themeBox');
    box.put('theme', themeMode.value);

    log(themeMode.value);
    // 通知改變
    notifyListeners();
  }

  /// 讀取 theme 設置記錄, 如果沒有記錄則默認跟隨系統主題
  /// themeMode 不允許返回 future type, 故有待修正
  Future<ThemeMode> getThemeMode() async {
    var box = await Hive.openBox('themeBox');
    final String theme = box.get('theme');
    switch (theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
