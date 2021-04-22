import 'package:flutter/cupertino.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:hive/hive.dart';

class IntlProvider extends ChangeNotifier {
  var box = Hive.box('box');

  Locale get locale {
    final String locale = box.get(Constant.locale);
    switch (locale) {
      case 'zh':
        return const Locale('zh', 'HK');
      case 'en':
        return const Locale('en', 'US');
      default:
        return null;
    }
  }

  void setLocale(String locale) {
    box.put(Constant.locale, locale);
    notifyListeners();
  }
}
