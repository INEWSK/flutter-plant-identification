import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatelessWidget {
  final File image;

  const ViewImage({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
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
          Positioned(
            child: Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: MaterialButton(
                padding: EdgeInsets.all(16.0),
                onPressed: () {}, // TODO: upload image to server
                color: Colors.green,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                shape: CircleBorder(),
              ),
            ),
            right: 0,
            bottom: 0,
            left: 0,
          )
        ],
      ),
    );
  }
}
