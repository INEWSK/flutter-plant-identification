import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final VoidCallback press;

  const ErrorPage({Key key, this.press}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/something_error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: size.height * 0.125,
            left: size.width * 0.3,
            right: size.width * 0.3,
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
              child: FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)),
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
