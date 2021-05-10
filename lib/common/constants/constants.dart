import 'package:flutter/foundation.dart';

class Constant {
  static const bool inProduction = kReleaseMode;

  static bool isDriverTest = false;
  static bool isUnitTest = false;

  static const String box = 'general';
  static const String authBox = 'authBox';

  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';

  static const String userAvatar = 'userAvatar';
  static const String username = 'username';
  static const String email = 'userEmail';
  static const String admin = 'isAdmin';

  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String theme = 'appTheme';
  static const String locale = 'locale';
  static const String seen = 'isSeen';

  static const String taskId = 'taskId';
}
