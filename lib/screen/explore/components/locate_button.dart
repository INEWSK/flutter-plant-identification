import 'package:flutter/material.dart';

class LocateButton extends StatelessWidget {
  final VoidCallback press;

  const LocateButton({Key key, this.press}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            tooltip: 'Locate',
            heroTag: 'lctbtn',
            onPressed: press,
            child: Icon(Icons.location_on),
          ),
        ),
      ),
    );
  }
}
