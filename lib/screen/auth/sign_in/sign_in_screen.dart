import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';

import 'components/create_account_button.dart';
import 'components/or_divider.dart';
import 'components/sign_in_form.dart';
import '../widgets/auth_background.dart';
import '../widgets/welcome_text.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthBackground(),
        Scaffold(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withAlpha(225),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: _body(context),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeText(
                title: AppLocalizations.of(context).welcome,
                text: AppLocalizations.of(context).signInText),
            SizedBox(height: 10),
            SignInForm(),
            SizedBox(height: 20),
            OrDivider(),
            SizedBox(height: 20),
            CreateAccountButton(),
            SizedBox(height: 20),
            // SocialAuthButton(),
          ],
        ),
      ),
    );
  }
}
