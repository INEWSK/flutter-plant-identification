import 'package:flutter/cupertino.dart';

class AppLogHelper {
  static void log(String methodName, String message) {
    debugPrint("{$methodName} {$message}");
  }
}
