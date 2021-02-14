import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'components/intro_card.dart';

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
          'Flora',
          style: GoogleFonts.balooPaaji(
            textStyle: TextStyle(color: Colors.green, fontSize: 26.0),
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 使用 Expanded 讓 listview 佔 column 餘下剩餘的空間
        Expanded(
          child: AnimationLimiter(
            child: ListView.builder(
              addAutomaticKeepAlives: false, // 本體已被包裹在 autoKeepAlive, 故禁用
              // shrinkWrap: true, // 確定 listview 高度
              // physics: NeverScrollableScrollPhysics(),
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
        ),
      ],
    );
  }
}
