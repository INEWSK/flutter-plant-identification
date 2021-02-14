import 'package:flutter/material.dart';

class LocationErrorPage extends StatelessWidget {
  final VoidCallback press;

  const LocationErrorPage({Key key, @required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/location_error.png",
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: size.height * 0.15,
          left: size.width * 0.3,
          right: size.width * 0.3,
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
            child: FlatButton(
              color: Color(0xFFFF9858),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
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
