import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
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

  static void notification({String title, String subtitle, int duration = 5}) {
    if (title == null) {
      return;
    }
    BotToast.showSimpleNotification(
      title: title,
      subTitle: subtitle ?? null,
      titleStyle: kBodyTextStyle.copyWith(color: Colors.white),
      subTitleStyle: kSecondaryBodyTextStyle.copyWith(color: Colors.white54),
      backgroundColor: const Color(0xFF303030),
      duration: Duration(seconds: duration),
      hideCloseButton: true,
      onlyOne: true,
      crossPage: false,
    );
  }

  static void error(
      {String title,
      String subtitle,
      IconData icon = Icons.error,
      int duration = 6}) {
    if (title == null) {
      return;
    }
    BotToast.showNotification(
      leading: (cancel) =>
          IconButton(icon: Icon(icon, color: Colors.white), onPressed: cancel),
      title: (_) => Text(
        title,
        style: kBodyTextStyle.copyWith(color: Colors.white),
      ),
      subtitle: (_) => subtitle != null
          ? Text(
              subtitle,
              style: kSecondaryBodyTextStyle.copyWith(color: Colors.white70),
            )
          : null,
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: duration),
      onlyOne: true,
      crossPage: false,
    );
  }

  static void cancel() {
    dismissAllToast();
  }
}
