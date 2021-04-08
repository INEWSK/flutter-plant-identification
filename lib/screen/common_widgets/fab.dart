import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/fluashbar_utils.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/screen/view_image/view_image_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class FAB extends StatelessWidget {
  final _picker = ImagePicker();

  void _pickImage(source, BuildContext context) async {
    try {
      final pickedFile = await _picker.getImage(source: source);

      if (pickedFile != null) {
        final image = File(pickedFile.path);

        debugPrint('FILE PATH: ${pickedFile.path}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewImageScreen(image: image),
          ),
        );
      } else {
        debugPrint('FILE PATH: 無文件被選擇');
      }
    } catch (e) {
      Flush.error(context, message: '沒有權限打開相冊');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'cameraButton',
      elevation: 6.0,
      child: IconButton(
        tooltip: 'Camera',
        icon: SvgPicture.asset(
          'assets/icons/navbar/camera.svg',
          color: Colors.white,
        ),
        onPressed: null,
      ),
      // onPressed: () async => this.pushToCamera(context),
      onPressed: () async {
        ImageSource source = await showDialog<ImageSource>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              // contentPadding: EdgeInsets.all(kDefaultPadding),
              title: Text('Select Image Source'),
              children: [
                _imageSourceOption(context, 'Gallery', ImageSource.gallery),
                _imageSourceOption(context, 'Camera', ImageSource.camera),
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
  }

  Widget _imageSourceOption(
      BuildContext context, String title, ImageSource source) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.pop(context, source);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(title),
      ),
    );
  }
}
