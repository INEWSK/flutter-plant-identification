import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset(
        'assets/svg/auth_background.svg',
        // height: Screen.height(context),
        // width: Screen.width(context),
        fit: BoxFit.fill,
      ),
    );
  }
}
