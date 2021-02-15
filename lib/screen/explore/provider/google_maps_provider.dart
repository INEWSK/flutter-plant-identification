import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

enum Status { Uninitialized, Authorization, Unauthorized }

class GoogleMapsProvider extends ChangeNotifier {
  Status _status = Status.Uninitialized;

  Status get status => _status;

  // 初始化定位權限
  void determindPermission() async {
    // 權限狀態
    PermissionStatus status = await Permission.location.status;

    if (!status.isGranted && !status.isPermanentlyDenied) {
      log('定位權限未授權或被拒絕');
      // 要求授權
      status = await Permission.location.request();
    }

    if (status.isDenied) {
      // 再次請求直至被永久拒絕
      determindPermission();
    }

    if (status.isPermanentlyDenied) {
      // 永久拒絕, 不執行其他動作
      log('定位權限被永久拒絕');
      _status = Status.Unauthorized;
      notifyListeners();
    }

    // 權限授權 => 跳轉地圖
    if (status.isGranted) {
      log('權限授權成功');
      _status = Status.Authorization;
      notifyListeners();
    }
  }

  // 定位權限請求
  void requestPermission() async {
    // 檢查權限
    PermissionStatus status = await Permission.location.status;

    // 如果依舊是永久拒絕則跳轉 APP 手動設定權限
    // Android 在設定中重新賦予或者取消權限會退出 APP
    // 後續不執行其他動作
    if (status.isPermanentlyDenied) {
      log('定位權限被永久拒絕, 嘗試打開 APP 設定頁面');
      bool opened = await openAppSettings();
      if (!opened) {
        log('Failed to open App Setting Page');
      }
    } else if (!status.isGranted) {
      status = await Permission.location.request();
    }

    // 如果已經在設定中賦予權限了則跳轉到地圖
    if (status.isGranted) {
      _status = Status.Authorization;
      notifyListeners();
    }
  }
}
