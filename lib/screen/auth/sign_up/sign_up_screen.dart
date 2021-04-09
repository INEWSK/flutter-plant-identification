import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/auth_background.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';

import 'components/sign_in_button.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthBackground(),
        Scaffold(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withAlpha(225),
          appBar: AppBar(),
          body: _body(),
        ),
      ],
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeText(
              title: 'Create Account',
              text: 'Enter your Email and Password for sign up.',
            ),
            SignUpForm(),
            SizedBox(height: 20),
            SignInButton(),
          ],
        ),
      ),
    );
  }
}
