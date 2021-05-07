import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:hive/hive.dart';

class IntlProvider extends ChangeNotifier {
  String defaultLocale = Platform.localeName;
  var box = Hive.box(Constant.box);

  Locale get locale {
    final String locale = box.get(Constant.locale);
    switch (locale) {
      case 'zh':
        return const Locale('zh', 'HK');
      case 'en':
        return const Locale('en', '');
      default:
        return null;
    }
  }

  void setLocale(String locale) {
    box.put(Constant.locale, locale);
    notifyListeners();
  }
}
