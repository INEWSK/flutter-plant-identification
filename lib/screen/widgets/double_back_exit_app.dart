import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';

class DoubleBackExitApp extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final String message;

  const DoubleBackExitApp({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 2500),
    this.message = "Press back again to exit",
  }) : super(key: key);

  @override
  _DoubleBackExitAppState createState() => _DoubleBackExitAppState();
}

class _DoubleBackExitAppState extends State<DoubleBackExitApp> {
  /// 記錄距離上一次 tap back 的時間
  DateTime _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: widget.child,
      onWillPop: _isExit,
    );
  }

  Future<bool> _isExit() async {
    if (Device.isAndroid) {
      if (_lastTime == null ||
          DateTime.now().difference(_lastTime) > widget.duration) {
        _lastTime = DateTime.now();
        Toast.show(widget.message);
        return Future.value(false);
      }
      Toast.cancel();
    }
    await SystemNavigator.pop();

    return Future.value(true);
  }
}
