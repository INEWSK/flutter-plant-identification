import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/screen/view_image/view_image_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class FAB extends StatelessWidget {
  final picker = ImagePicker();

  void _pickImage(source, BuildContext _) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      final image = File(pickedFile.path);

      log('FILE PATH: ${pickedFile.path}');

      Navigator.push(
        _,
        MaterialPageRoute(
          builder: (context) => ViewImageScreen(image: image),
        ),
      );
    } else {
      Toast.show('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0.0,
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
