import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/screen/agreement/agreement_screen.dart';
import 'package:flutter_hotelapp/screen/auth/forgot/email_sent_screen.dart';
import 'package:flutter_hotelapp/screen/auth/forgot/forgot_screen.dart';
import 'package:flutter_hotelapp/screen/auth/sign_in/sign_in_screen.dart';
import 'package:flutter_hotelapp/screen/auth/sign_up/sign_up_screen.dart';
import 'package:flutter_hotelapp/screen/labor/labor_screen.dart';
import 'package:flutter_hotelapp/screen/main_screen.dart';
import 'package:flutter_hotelapp/screen/onboarding/onboarding_screen.dart';
// import 'package:flutter_hotelapp/screen/mlkit/ml_kit_screen.dart';
import 'package:flutter_hotelapp/screen/profile/fqa_screen.dart';
import 'package:flutter_hotelapp/screen/settings/settings_screen.dart';

class Routes {
  // prevent anyone from instantiate this object
  Routes._();

  static const String intro = '/intro';
  static const String main = '/main';
  static const String signIn = '/signIn';
  static const String signUp = '/signUp';
  static const String forgot = '/forgot';
  static const String emailSent = '/emailSent';
  static const String settings = '/settings';
  static const String agreement = '/agreement';
  static const String fqa = '/fqa';
  static const String labor = '/labor';
  static const String tensorflow = '/tensorflow';
  static const String mlkit = '/mlkit';

  static final routes = <String, WidgetBuilder>{
    intro: (BuildContext context) => OnBoardingScreen(),
    main: (BuildContext context) => MainScreen(),
    signIn: (BuildContext context) => SignInScreen(),
    signUp: (BuildContext context) => SignUpScreen(),
    forgot: (BuildContext context) => ForgotScreen(),
    emailSent: (BuildContext context) => EmailSentScreen(),
    settings: (BuildContext context) => SettingsScreen(),
    agreement: (BuildContext context) => AgreementScreen(),
    fqa: (BuildContext context) => FQAScreen(),
    labor: (BuildContext context) => LaborScreen(),
    // mlkit: (BuildContext context) => MLKitScreen(),
  };
}
