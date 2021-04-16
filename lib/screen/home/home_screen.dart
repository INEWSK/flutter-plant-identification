import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'components/intro_card.dart';
import 'provider/home_provider.dart';

/// 使用 AutomaticKeepAliveClientMixin，並重寫 wantKeepAlive 方法，讓狀態不被回收掉
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tree Doctor',
          style: GoogleFonts.balooPaaji(
            textStyle: TextStyle(color: Colors.green, fontSize: 26.0),
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: Consumer(
        builder: (_, HomeProvider provider, __) {
          return FutureBuilder(
            future: provider.fetchData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  // final List<TreeInfo> data = snapshot.data;
                  return _buildList(provider);
                } else {
                  // demo local data
                  return _demoList(provider);
                }
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCube(color: Colors.teal),
                    SizedBox(height: 40),
                    Text('Loading...'),
                  ],
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildList(HomeProvider provider) {
    return RefreshIndicator(
      onRefresh: () async => provider.reloadData(),
      child: AnimationLimiter(
        child: ListView.builder(
          addAutomaticKeepAlives: false, // 本體已被包裹在 autoKeepAlive, 禁用
          itemCount: provider.list.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: kDefaultDuration,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: IntroCard(
                    sort: provider.list[index].infoType,
                    title: provider.list[index].title,
                    text: provider.list[index].content,
                    image: demoIntroCardData[index]["image"],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _demoList(HomeProvider provider) {
    return RefreshIndicator(
      onRefresh: () async => provider.reloadData(),
      child: AnimationLimiter(
        child: ListView.builder(
          addAutomaticKeepAlives: false, // 本體已被包裹在 autoKeepAlive, 禁用
          itemCount: demoIntroCardData.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: kDefaultDuration,
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: IntroCard(
                    sort: demoIntroCardData[index]["sort"],
                    title: demoIntroCardData[index]["title"],
                    text: demoIntroCardData[index]["text"],
                    image: demoIntroCardData[index]["image"],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
