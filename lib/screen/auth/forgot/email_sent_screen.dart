import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';

class EmailSentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeText(
              title: "Reset email sent",
              text:
                  "We have sent a instruction email to \nyour inbox. Please check out."),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
