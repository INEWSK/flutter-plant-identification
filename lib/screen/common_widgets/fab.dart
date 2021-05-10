import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/logger_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/models/tree_data.dart' as tree;
import 'package:flutter_hotelapp/provider/api_provider.dart';
import 'package:flutter_hotelapp/screen/detail/detail_screen.dart';
import 'package:flutter_hotelapp/screen/view_image/view_image_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FAB extends StatelessWidget {
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
      final tree.Result data = response['data'];
      BotToast.showNotification(
        leading: (cancel) => IconButton(
          icon: Icon(Ionicons.ios_rose, color: Colors.redAccent),
          onPressed: cancel,
        ),
        title: (_) => Text('AI 預測結果', style: kBodyTextStyle),
        subtitle: (_) => Text(result),
        // 沒有傳回 data 或 data 爲 null 不顯示 '查看更多' 標題
        trailing: (cancel) => data != null
            ? TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            DetailScreen(data: data, type: DataType.Tree)),
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
        trailing: (_) => Text(
          '嘗試 ML Kit?',
          style: TextStyle(color: Colors.white70),
        ),
        onTap: () => Navigator.pushNamed(context, '/labor'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 7),
        crossPage: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApiProvider>(builder: (_, api, __) {
      return FloatingActionButton(
        heroTag: 'cameraButton',
        elevation: 6.0,
        child: api.isLoading
            ? SpinKitFadingCircle(
                color: Colors.white,
                size: 36,
              )
            : IconButton(
                tooltip: AppLocalizations.of(context).camera,
                icon: SvgPicture.asset(
                  'assets/icons/navbar/camera.svg',
                  color: Colors.white,
                ),
                onPressed: null,
              ),
        // onPressed: () async => this.pushToCamera(context),
        onPressed: api.isLoading
            ? null
            : () async {
                ImageSource source = await showDialog<ImageSource>(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      // contentPadding: EdgeInsets.all(kDefaultPadding),
                      title: Text(AppLocalizations.of(context).selectImage),
                      children: [
                        _imageSourceOption(
                          context,
                          AppLocalizations.of(context).gallery,
                          Ionicons.ios_albums,
                          ImageSource.gallery,
                        ),
                        _imageSourceOption(
                          context,
                          AppLocalizations.of(context).camera,
                          Ionicons.ios_camera,
                          ImageSource.camera,
                        ),
                      ],
                    );
                  },
                );
                switch (source) {
                  case ImageSource.camera:
                    _pickImage(ImageSource.camera, context);
                    break;
                  case ImageSource.gallery:
                    _pickImage(ImageSource.gallery, context);
                    break;
                }
              },
      );
    });
  }

  Widget _imageSourceOption(
      BuildContext context, String title, IconData icon, ImageSource source) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, source);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(icon),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
