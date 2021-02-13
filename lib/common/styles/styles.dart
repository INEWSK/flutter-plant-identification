import 'package:flutter/material.dart';

//------ padding here ------//
// app default padding
final kDefaultPadding = 20.0;

// app text field padding
final EdgeInsets kTextFieldPadding = EdgeInsets.all(kDefaultPadding);

// OKToast text padding
final EdgeInsets kToastPadding = EdgeInsets.symmetric(
  horizontal: 16.0,
  vertical: 10.0,
);

// default animation duration
const Duration kDefaultDuration = Duration(milliseconds: 375);

//------ auth text input border style  here ------//
// text field decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
  borderSide: const BorderSide(
    color: Colors.white70,
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

//------ dynamic text styles here ------//
final TextStyle kH1TextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.22,
  color: Colors.green,
);

final TextStyle kH2TextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.18,
);

final TextStyle kH3TextStyle = kH2TextStyle.copyWith(
  fontSize: 20,
  letterSpacing: 0.14,
);

final TextStyle kSubHeadTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  letterSpacing: 0.44,
);

final TextStyle kInputTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  // height: 1.5,
);

final TextStyle kBodyTextStyle = TextStyle(
  fontSize: 14,
  // color: Color(0xFF3D3D3D),
  height: 1.5,
);

final TextStyle kSecondaryBodyTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  // height: 1.5,
);

final TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);
