import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'view_image.dart';

class FAB extends StatelessWidget {
  final picker = ImagePicker();

  void _pickImage(source, BuildContext _) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      Navigator.push(
        _,
        MaterialPageRoute(
          builder: (context) => ViewImage(image: image),
        ),
      );
    } else {
      Toast.show('No Image Select');
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
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                  child: Text('Gallery'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                  child: Text('Camera'),
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
  }
}
