import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
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
        Positioned(
          child: Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: MaterialButton(
              padding: const EdgeInsets.all(16.0),
              onPressed: () => Navigator.of(context)
                  .pop(_upload(image)), // TODO: upload image to server
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
    );
  }

  // TODO: MVC
  void _upload(File file) async {
    // 取檔案路徑最後一個 '/' 餘後的內容作為檔案名字.
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      )
    });

    Dio dio = Dio();

    dio
        .post('http://10.0.2.2:8000/flora/tree-ai/', data: data)
        .then((response) {
      String msg = response.toString();
      log('SERVER RESPONSE: $response');
      Toast.show(msg);
    }).catchError((onError) => print(onError));
  }
}
