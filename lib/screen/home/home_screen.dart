import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
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
        builder: (_, HomeProvider home, __) {
          return RefreshIndicator(
            onRefresh: () => home.refresh(),
            child: AnimationLimiter(
              child: ListView.builder(
                addAutomaticKeepAlives: false, // 本體已被包裹在 autoKeepAlive, 禁用
                itemCount: demoIntroCardData.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 375),
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
        },
      ),
    );
  }
}
