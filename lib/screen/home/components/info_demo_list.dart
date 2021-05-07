import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/screen/home/provider/home_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'intro_card.dart';

class InfoDemoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, home, __) {
        return RefreshIndicator(
          onRefresh: () async => home.fetchApiData().then((success) {
            if (!success) Toast.error(title: '請檢查網絡狀態');
          }),
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
                        index: index,
                        sort: demoIntroCardData[index]["sort"],
                        title: demoIntroCardData[index]["title"],
                        text: demoIntroCardData[index]["text"],
                        image: null,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
