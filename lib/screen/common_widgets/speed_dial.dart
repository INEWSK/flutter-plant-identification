import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;
import 'package:flutter_hotelapp/models/tree_locations.dart';
import 'package:flutter_hotelapp/provider/api_provider.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/view_image/view_image_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SpeedDial extends StatelessWidget {
  final controller;

  const SpeedDial({Key key, @required this.controller}) : super(key: key);

  static const List<Map<String, dynamic>> items = const [
    {"icon": Icons.album, "title": "Gallery", "source": ImageSource.gallery},
    {"icon": Icons.camera_alt, "title": "Camera", "source": ImageSource.camera}
  ];

  void _pickImage(source, BuildContext context) async {
    final _picker = ImagePicker();

    try {
      final pickedFile = await _picker.getImage(source: source);

      if (pickedFile != null) {
        final image = File(pickedFile.path);

        debugPrint('FILE PATH: ${pickedFile.path}');
        // 導航到預覽圖片, 如果返回 true 則進行上傳圖片動作
        final result = await _viewImage(context, image);

        if (result) {
          _uploadImage(context, image);
        }
      } else {
        debugPrint('FILE PATH: 無文件被選擇');
      }
    } catch (e) {
      LoggerUtils.show(messageType: Type.Error, message: e.toString());
      Toast.error(title: '錯誤', subtitle: '沒有權限打開相冊');
    }
  }

  Future<void> _uploadImage(BuildContext context, File image) async {
    final response = await context.read<ApiProvider>().upload(image);

    _resultToast(context, response);
  }

  Future<bool> _viewImage(BuildContext context, File image) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewImageScreen(image: image),
      ),
    );

    if (result == null) {
      return false;
    }

    return result;
  }

  void _resultToast(BuildContext context, Map response) {
    final bool success = response['success'];
    final String result = response['result'];

    if (success) {
      // 用 treelocation 是因爲這條api可以call所有tree data
      final TreeLocation data = response['data'];
      BotToast.showNotification(
        leading: (cancel) => IconButton(
          icon: Icon(Ionicons.ios_rose, color: Colors.redAccent),
          onPressed: cancel,
        ),
        title: (_) => Text('AI 預測結果', style: kBodyTextStyle),
        subtitle: (_) => Text(result),
        // 沒有傳回 data 或 data 爲 null 不顯示 '查看更多' 標題
        trailing: (_) => data != null
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailScreen(data: data, type: DataType.GoogleMap)),
                  );
                },
                child: Text('查看更多'))
            // 同上, 無視點擊事件
            : null,
        duration: Duration(minutes: 1),
        crossPage: false,
      );
    } else {
      BotToast.showNotification(
        leading: (cancel) => IconButton(
          icon: Icon(Ionicons.ios_warning, color: Colors.white),
          onPressed: cancel,
        ),
        title: (_) => Text('AI 發生了故障!',
            style: kBodyTextStyle.copyWith(color: Colors.white)),
        subtitle: (_) => Text(result,
            style: kSecondaryBodyTextStyle.copyWith(color: Colors.white54)),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 7),
        crossPage: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: kDefaultPadding * 0.88),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (int index) {
          Widget child = Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: controller,
                curve: Interval(0.0, 1.0 - index / items.length / 2.0,
                    curve: Curves.easeInOut),
              ),
              child: FloatingActionButton(
                heroTag: null,
                backgroundColor: Theme.of(context).cardColor,
                mini: true,
                child: IconButton(
                  tooltip: items[index]["title"],
                  icon: Icon(items[index]["icon"]),
                  onPressed: null,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  _pickImage(items[index]["source"], context);
                  //點擊收起 menu
                  controller.reverse();
                },
              ),
            ),
          );
          return child;
        }).toList()
          ..add(
            Consumer<ApiProvider>(
              builder: (_, api, __) {
                return FloatingActionButton(
                  elevation: 2,
                  heroTag: null,
                  child: AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget child) {
                      return Transform(
                        transform:
                            Matrix4.rotationZ(controller.value * 0.5 * math.pi),
                        alignment: FractionalOffset.center,
                        child: api.isLoading
                            ? SpinKitFadingCircle(
                                color: Colors.white,
                                size: 36,
                              )
                            : controller.isDismissed
                                ? IconButton(
                                    tooltip:
                                        AppLocalizations.of(context).camera,
                                    icon: SvgPicture.asset(
                                      'assets/icons/navbar/camera.svg',
                                      color: Colors.white,
                                    ),
                                    onPressed: null,
                                  )
                                : Icon(Icons.close),
                      );
                    },
                  ),
                  onPressed: api.isLoading
                      //ai 辨識途中禁止button點擊
                      ? null
                      : () async {
                          if (controller.isDismissed) {
                            controller.forward();
                          } else {
                            controller.reverse();
                          }
                          //震動反饋
                          if (Device.isMobile &&
                              await Vibration.hasVibrator()) {
                            Vibration.vibrate(duration: 10); //0.1s
                          }
                        },
                );
              },
            ),
          ),
      ),
    );
  }
}
