import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

extension ThemeModeExtension on ThemeMode {
  get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  void syncTheme() async {
    // var box = await Hive.openBox('themeBox');
    // final String theme = box.get('theme');
    final String theme = SpUtil.getString('theme');

    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  // 持久化主題設置
  void setTheme(ThemeMode themeMode) async {
    SpUtil.putString('theme', themeMode.value);
    log(themeMode.value);
    // themeMode已改變 通知widget更新
    notifyListeners();
  }

  /// 讀取 theme 設置記錄, 如果沒有記錄則默認跟隨系統主題
  /// themeMode 不允許返回 future type
  ThemeMode getThemeMode() {
    final String theme = SpUtil.getString('theme');
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
