import 'dart:developer';

/// print log error utils
class LogError {
  final methodName;
  final message;

  LogError(this.methodName, this.message);

  static void show(String methodName, String message,
      {String code = 'NO CODE'}) {
    log('Error Method: $methodName \nError Code: $code\nError Message: $message');
  }
}
