import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_sample_screen.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/plant_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: SvgPicture.asset('assets/icons/filter.svg'),
            onPressed: () {
              showSearch(context: context, delegate: SearchBar());
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSampleScreen(),
                  ),
                ),
                child: Text('Detail Page Template'),
              ),
              _treeDataCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _treeDataCard() {
    return FutureBuilder(
      future: _fetchTreeData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<TreeData> data = snapshot.data;
          return ListView.builder(
            //每個viewbuilder都有shrinkwrap用於確認屏幕可滾動大小
            //若false則嘗試占用整個父級空間,否則只用子級内容所需大小, 但仍會滾動
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // 停用 listview 自帶滾動
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return PlantCard(
                title: data[index].commonName,
                imgSrc: 'assets/images/bauhinia_blakeana.jpg',
                sname: data[index].scientificName,
                intro: data[index].introduction,
                press: () {},
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  _fetchTreeData() async {
    try {
      var dio = Dio(BaseOptions(
        baseUrl: "http://10.0.2.2:8000/flora/tree",
        connectTimeout: 5000,
        receiveTimeout: 100000,
        // 5s
        headers: {
          HttpHeaders.acceptHeader: "application/json",
          HttpHeaders.userAgentHeader: "",
          HttpHeaders.acceptLanguageHeader: 'en-US',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ));

      Response response;

      response = await dio.get("/");

      //------------------------------------------------------------------

      /// 思路: 如果直接返回repsonse.data則是String給someFunc使用
      log('Type of this variable is: ${response.data.runtimeType}'); //<--string
      // 這里 decode json 為 list<dynamic>
      var jsonData = jsonDecode(response.data);
      log('Decode Data is: ${jsonData[1]["common_name"]} and type of this variable is: ${jsonData.runtimeType}');

      // 這是呼叫 method 先 decode json 后再轉換為 list<model>
      var data = treeResponseFromJson(response.data);
      log('Model Data is: ${data[1].commonName} type of this variable is: ${data.runtimeType}');

      ///the data which you are receiving after hitting a
      ///webservice is in form of List but inside data class which you have
      ///used is of type Map .So, it is unable to parse the data due to
      ///structure mismatch as Map is defined in instead of List in data class.
      //這里抛出錯誤 list type不是 map type
      // var treeMap = TreeData.fromJson(jsonData);
      // log('Type of this variable is: ${jsonData.runtimeType}');

      // Response<Map> responseMap = await dio.get(
      //   "/",
      //   // Transform response data to Json Map
      //   options: Options(responseType: ResponseType.json),
      // );
      // print(responseMap.data);

      return data;
    } catch (e) {
      print(e);
    }
  }

  //這個是將map type 轉成 list type 用於lisview builder
  List<TreeData> treeResponseFromJson(String str) =>
      List<TreeData>.from(json.decode(str).map((x) => TreeData.fromJson(x)));
}
