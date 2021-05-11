import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/screen_utils.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/welcome_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'components/forgot_form.dart';

class ForgotScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: SvgPicture.asset(
            "assets/svg/forgot_password_gi2d.svg",
            width: Screen.width(context) * 0.78, // 78%
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeText(
                title: AppLocalizations.of(context).forgotPassword,
                text: AppLocalizations.of(context).forgotText,
              ),
              SizedBox(height: 20),
              ForgotForm(),
            ],
          ),
        ),
      ],
    );
  }
}
