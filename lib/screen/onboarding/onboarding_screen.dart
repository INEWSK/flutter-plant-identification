import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/constants/constants.dart';
import 'package:flutter_hotelapp/common/demo/demo_data.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/common_widgets/dot_indicator.dart';
import 'package:flutter_hotelapp/screen/common_widgets/primary_button.dart';
import 'package:hive/hive.dart';
import 'components/onboard_content.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentPage = 0;

  void _onIntroEnd(context) {
    var box = Hive.box(Constant.box);

    /// FOR remember the user already seen the demo
    box.put(Constant.seen, true);
    Navigator.popAndPushNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    /// deactivated user press back button to exit this page
    return WillPopScope(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Spacer(flex: 3),
              Expanded(
                flex: 9,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  // demo data content
                  itemCount: demoOnBoardingData.length,
                  itemBuilder: (context, index) => OnBoardContent(
                    svg: demoOnBoardingData[index]["svg"],
                    title: demoOnBoardingData[index]["title"],
                    text: demoOnBoardingData[index]["text"],
                  ),
                ),
              ),
              Spacer(),
              // dot indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(demoOnBoardingData.length,
                    (index) => DotIndicator(isActive: index == currentPage)),
              ),
              Spacer(flex: 2),
              // primary button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: PrimaryButton(
                  press: () => _onIntroEnd(context),
                  text: "Get Started",
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),

      /// user pop behaviour is not allowed
      onWillPop: () async => false,
    );
  }
}
