import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';

class GoogleMapsButton extends StatelessWidget {
  final VoidCallback locatePress;
  final VoidCallback arPress;

  const GoogleMapsButton({
    Key key,
    this.locatePress,
    this.arPress,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment:
            Device.isAndroid ? Alignment.topRight : Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              FloatingActionButton(
                tooltip: 'Locate',
                heroTag: 'lctbtn',
                onPressed: locatePress,
                child: Icon(Icons.my_location),
              ),
              SizedBox(height: 15.0),
              FloatingActionButton(
                tooltip: 'AR',
                heroTag: 'arbtn',
                onPressed: arPress,
                child: Icon(
                  Icons.remove_red_eye,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
