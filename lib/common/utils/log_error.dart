import 'dart:developer';

/// print log error utils
class LogError {
  static void show(String code, String message) =>
      log('Error: $code\nError Message: $message');
}
