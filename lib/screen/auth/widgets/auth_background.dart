import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: SvgPicture.asset(
        'assets/svg/auth_background.svg',
        height: size.height,
        width: size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
