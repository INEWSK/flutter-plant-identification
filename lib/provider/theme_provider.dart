import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:hive/hive.dart';

extension ThemeModeExtension on ThemeMode {
  get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  var box = Hive.box(Constant.box);

  void syncTheme() async {
    final String theme = box.get(Constant.theme);

    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  void setTheme(ThemeMode themeMode) async {
    // 持久化主題設置
    box.put(Constant.theme, themeMode.value);
    log(themeMode.value);
    // themeMode已改變 通知widget更新
    notifyListeners();
  }

  /// 讀取 theme 記錄, 如果沒有記錄則默認跟隨系統主題
  ThemeMode getThemeMode() {
    final String theme = box.get(Constant.theme);
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
