import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _test(),
      // body: _body(),
    );
  }

  // Widget _body() {
  //   return Center();
  // }

  Widget _test() {
    return FutureBuilder(
      future: fetchTreeData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Press button to start');
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default: //如果完成
            if (snapshot.hasError) {
              //若出現異常
              print("[X]ERROR");
              return Text('Error: ${snapshot.error}');
            } else //若正常完成
              print('DONE. DATA: ${snapshot.data}');
            return Text('DATA:\n ${snapshot.data}');
        }
      },
    );
  }

  fetchTreeData() async {
    try {
      var dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/flora/tree",
        connectTimeout: 5000,
        receiveTimeout: 100000,
        // 5s
        headers: {
          HttpHeaders.userAgentHeader: "",
          HttpHeaders.acceptLanguageHeader: 'en-US',
        },
        contentType: Headers.jsonContentType,
        // Transform the response data to a String encoded with UTF8.
        // The default value is [ResponseType.JSON].
        responseType: ResponseType.plain,
      ));

      Response response;

      response = await dio.get("/");

      return (response.data);

      // Response<Map> responseMap = await dio.get(
      //   "/",
      //   // Transform response data to Json Map
      //   options: Options(responseType: ResponseType.json),
      // );
      // print(responseMap.data);
    } catch (e) {
      print(e);
    }
  }
}
