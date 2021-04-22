import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/common_widgets/primary_button.dart';
import 'package:photo_view/photo_view.dart';

class ViewImageScreen extends StatelessWidget {
  final File image;

  const ViewImageScreen({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
          imageProvider: FileImage(image),
          loadingBuilder: (context, progress) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          gaplessPlayback: false,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
          initialScale: PhotoViewComputedScale.contained,
          basePosition: Alignment.center,
        ),
        // 確認按鈕
        Positioned(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding,
              horizontal: kDefaultPadding * 2.5,
            ),
            child: PrimaryButton(
              press: () {
                //呼叫 api upload image 並關閉當前頁
                Navigator.of(context).pop(true);
              },
              text: AppLocalizations.of(context).upload,
            ),
          ),
          right: 0,
          bottom: 0,
          left: 0,
        ),
      ],
    );
  }
}
