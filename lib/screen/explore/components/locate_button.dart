import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';

class LocateButton extends StatelessWidget {
  final VoidCallback press;

  const LocateButton({Key key, this.press}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment:
            Device.isAndroid ? Alignment.topRight : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            tooltip: 'Locate',
            heroTag: 'lctbtn',
            onPressed: press,
            child: Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}
