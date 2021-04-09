import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/screen_utils.dart';

class ErrorPage extends StatelessWidget {
  final Function press;

  const ErrorPage({Key key, this.press}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/something_error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: Screen.height(context) * 0.125,
            left: Screen.width(context) * 0.3,
            right: Screen.width(context) * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 13),
                    blurRadius: 25,
                    color: Color(0xFF5666C2).withOpacity(0.17),
                  ),
                ],
              ),
              child: ElevatedButton(
                //繼承 elevated button 的 style 再改變 style 屬性
                style: ElevatedButton.styleFrom(primary: Colors.white),
                // color: Colors.white,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(45)),
                onPressed: press,
                child: Text(
                  "retry".toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
