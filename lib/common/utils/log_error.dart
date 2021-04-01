import 'dart:developer';

/// print log error utils
class LogError {
  static void show(String message, String methodName,
      {String code = 'NO CODE'}) {
    log('Error: Method -> $methodName \nError Code: $code\nError Message: $message');
  }
}
