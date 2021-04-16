// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class Flush {
//   static void notification(BuildContext context,
//       {String title, String message, Icon icon, int duration = 3000}) {
//     if (message != null) {
//       Flushbar(
//         title: title,
//         message: message,
//         icon: icon,
//         duration: Duration(milliseconds: duration),
//         flushbarStyle: FlushbarStyle.FLOATING,
//         margin: EdgeInsets.all(5.0),
//         borderRadius: BorderRadius.circular(5.0),
//         forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//         reverseAnimationCurve: Curves.easeInOut,
//       )..show(context);
//     } else {
//       return;
//     }
//   }

//   static void error(
//     BuildContext context, {
//     String title,
//     String message,
//     int duration = 4000,
//     FlushbarPosition position = FlushbarPosition.TOP,
//   }) {
//     if (message != null) {
//       Flushbar(
//         title: title,
//         message: message,
//         icon: Icon(Icons.error, color: Colors.white),
//         flushbarPosition: position,
//         backgroundColor: Colors.redAccent,
//         duration: Duration(milliseconds: duration),
//         flushbarStyle: FlushbarStyle.FLOATING,
//         margin: EdgeInsets.all(5.0),
//         borderRadius: BorderRadius.circular(5.0),
//         forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//         reverseAnimationCurve: Curves.easeInOut,
//       )..show(context);
//     } else {
//       return;
//     }
//   }

//   static void cancelbar() {
//     Flushbar().dismiss();
//   }
// }
