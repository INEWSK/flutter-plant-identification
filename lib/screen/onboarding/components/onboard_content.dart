import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardContent extends StatelessWidget {
  final String svg, title, text;

  const OnBoardContent({
    Key key,
    this.svg,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            //長寬比 1:1
            aspectRatio: 1,
            child: SvgPicture.asset(svg),
          ),
        ),
        SizedBox(height: 50),
        Text(
          title,
          style: kH2TextStyle,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          text,
          style: kBodyTextStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
