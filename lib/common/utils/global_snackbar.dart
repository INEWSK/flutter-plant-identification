import 'package:flutter/material.dart';

/// 調用 snackbar 時進行轉頁會導致 ScaffoldMessenger hero animation error
/// 目前的解決方案是用 willPopScope 包裹手腳架然後執行 removeCurrentSnackbar
/// 但此舉會製造大量重複代碼
/// 狀態: 放棄使用 snackbar

class GlobalSnackBar {
  final String message;

  const GlobalSnackBar({@required this.message});

  static show(BuildContext context, String message) {
    print('press');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          textColor: Color(0xFFFAF2FB),
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }
}
