import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';

class LaborScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: WelcomeText(title: '實驗室', text: '以下功能爲實驗性功能 (測試階段)'),
        ),
        ListTile(
          title: Text('Tensorflow Lite'),
          onTap: () => Navigator.pushReplacementNamed(context, '/tensorflow'),
        ),
        ListTile(
          title: Text('Firebase ML Kit'),
          onTap: () => Navigator.pushReplacementNamed(context, '/mlkit'),
        ),
      ],
    );
  }
}
