import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';

class WelcomeText extends StatelessWidget {
  final String title, text;

  const WelcomeText({Key key, @required this.title, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(title, style: kH1TextStyle),
        SizedBox(height: 10),
        Text(text, style: kBodyTextStyle.copyWith(fontSize: 16.0)),
        SizedBox(height: 20),
      ],
    );
  }
}
