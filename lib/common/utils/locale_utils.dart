import 'dart:io';

import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:hive/hive.dart';

class LocaleUtils {
  static String get getLocale {
    var box = Hive.box(Constant.box);

    final String locale = box.get(Constant.locale);
    switch (locale) {
      case 'zh':
        return 'zh-HK';
      case 'en':
        return 'en-US';
      default:
        // 如果系統語言開頭是 zh 則 return 繁體
        if (Platform.localeName.startsWith('zh')) {
          return 'zh-HK';
        } else {
          return 'en-US';
        }
    }
  }
}
