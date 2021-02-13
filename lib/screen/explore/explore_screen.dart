import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'components/google_maps.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  bool permitted = false;
  PermissionStatus status;

  @override
  void initState() {
    super.initState();
    _determindPermission();
  }

  // 檢測權限
  void _determindPermission() async {
    // 權限狀態
    status = await Permission.location.status;

    if (!status.isGranted && !status.isPermanentlyDenied) {
      debugPrint('定位權限未授權或曾被拒絕');
      // 要求授權
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      debugPrint('定位權限被永久拒絕');
      // 自行按 BUTTON 到 APP 設定開啓權限
    }

    // 如果授權了跳轉到地圖
    if (status.isGranted) {
      debugPrint('權限授權成功');
      setState(() {
        permitted = true;
      });
    }
  }

  void _requestPermission() async {
    // 重新獲取 status 狀態用作判斷當前權限狀態
    status = await Permission.location.status;

    // 如果依舊是永久拒絕則跳轉設定
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      status = await Permission.location.request();
    }

    // 如果已經在設定中賦予權限了則跳轉到地圖
    if (status.isGranted) {
      setState(() {
        permitted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: permitted
          ? GoogleMaps()
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/location_error.png",
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: size.height * 0.15,
                  left: size.width * 0.3,
                  right: size.width * 0.3,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 13),
                          blurRadius: 25,
                          color: Color(0xFFD27E4A).withOpacity(0.17),
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Color(0xFFFF9858),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45)),
                      onPressed: () {
                        _requestPermission();
                      },
                      child: Text(
                        "Enable".toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
