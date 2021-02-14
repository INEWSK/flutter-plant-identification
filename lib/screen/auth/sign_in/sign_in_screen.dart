import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';

import 'components/create_account_button.dart';
import 'components/or_divider.dart';
import 'components/sign_in_form.dart';
import 'components/social_auth_button.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
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
                title: 'Welcome',
                text:
                    'Enter your Phone number or Email address \nand Password for Sign In ;)'),
            SignInForm(),
            SizedBox(height: 20),
            OrDivider(),
            SizedBox(height: 20),
            CreateAccountButton(),
            SizedBox(height: 20),
            SocialAuthButton(),
          ],
        ),
      ),
    );
  }
}
