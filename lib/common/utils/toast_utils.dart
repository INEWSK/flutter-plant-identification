import 'package:oktoast/oktoast.dart';

/// OKToast utils
class Toast {
  static void show(String message, {int duration = 2500}) {
    if (message == null) {
      return;
    }
    showToast(
      message,
      duration: Duration(milliseconds: duration),
      dismissOtherToast: true,
    );
  }

  static void cancel() {
    dismissAllToast();
  }
}
