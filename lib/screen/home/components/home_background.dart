import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/screen_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SvgPicture.asset(
        'assets/svg/home_background.svg',
        height: Screen.height(context),
        width: Screen.width(context),
        fit: BoxFit.cover,
      ),
    );
  }
}
