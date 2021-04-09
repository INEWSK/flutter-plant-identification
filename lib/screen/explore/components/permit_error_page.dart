import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/screen_utils.dart';

class PermitErrorPage extends StatelessWidget {
  final VoidCallback press;

  const PermitErrorPage({Key key, @required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/location_error.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: Screen.height(context) * 0.15,
          left: Screen.width(context) * 0.3,
          right: Screen.width(context) * 0.3,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 25,
                  color: Color(0xFFD27E4A).withOpacity(0.17),
                ),
              ],
            ),
            child: ElevatedButton(
              // color: Color(0xFFFF9858),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(45)),
              onPressed: press,
              child: Text(
                "Enable".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
