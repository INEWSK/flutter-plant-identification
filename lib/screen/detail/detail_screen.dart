import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';

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
      body: Center(
        child: _buildTreeData(),
      ),
      // body: _body(),
    );
  }

  // Widget _body() {
  //   return Center();
  // }

  Widget _buildTreeData() {
    return FutureBuilder(
      future: _fetchTreeData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // by default, show a loading spinner
        return CircularProgressIndicator();
      },
    );
  }

  // wOOOOOOOOOOOOOOOOOOOOOOOoooooooooow
  List<TreeData> treeResponseFromJson(String str) =>
      List<TreeData>.from(json.decode(str).map((x) => TreeData.fromJson(x)));

  _fetchTreeData() async {
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

      var treeMap = jsonDecode(response.data); // 這里 decode 了 list<dynamic>

      ///the data which you are receiving after hitting a
      ///webservice is in form of List but inside data class which you have
      ///used is of type Map .So, it is unable to parse the data due to
      ///structure mismatch as Map is defined in instead of List in data class.
      ///
      // var treeData = TreeData.fromJson(treeMap[1]); // fuck this shit
      // log(treeData.commonName);

      var treeList = treeResponseFromJson(response.data);
      // print(treeList);

      return treeList;

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
