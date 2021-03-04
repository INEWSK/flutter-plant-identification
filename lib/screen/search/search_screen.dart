import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/models/tree_data.dart';
import 'package:flutter_hotelapp/screen/detail/detail_sample_screen.dart';
import 'package:flutter_hotelapp/screen/search/provider/tree_data_provider.dart';
import 'package:flutter_hotelapp/screen/widgets/search_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
      body: ChangeNotifierProvider(
        create: (BuildContext context) => TreeDataProvider(),
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return Consumer<TreeDataProvider>(builder: (_, tree, __) {
      return Container(
        child: _treeDataCard(tree),
      );
    });
  }

  Widget _treeDataCard(TreeDataProvider tree) {
    return FutureBuilder(
      future: tree.fetchTreeData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<TreeData> data = snapshot.data;
          return ListView.builder(
            //每個viewbuilder都有shrinkwrap用於確認屏幕可滾動大小
            //若false則嘗試占用整個父級空間,否則只用子級内容所需大小, 但仍會滾動
            // shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return PlantCard(
                title: data[index].commonName,
                imgSrc: 'assets/images/bauhinia_blakeana.jpg',
                sname: data[index].scientificName,
                intro: data[index].introduction,
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSampleScreen(),
                  ),
                ),
              );
            },
          );
        } else {
          return _shimmer(); // 刷新畫面
        }
      },
    );
  }

  Widget _shimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding:
                EdgeInsets.symmetric(vertical: kDefaultPadding), // 每個 item 間距
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          itemCount: 6,
        ),
      ),
    );
  }
}
