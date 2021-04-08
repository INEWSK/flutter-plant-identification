import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/device_utils.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final GestureTapCallback press;

  const PrimaryButton({Key key, @required this.text, @required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: 16.0);

    return SizedBox(
      width: double.infinity,
      child: Device.isIOS
          ? CupertinoButton(
              padding: verticalPadding,
              color: Colors.green,
              onPressed: press,
              // borderRadius: BorderRadius.all(Radius.circular(50.0)),
              child: textContext(context),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: verticalPadding,
              ),
              onPressed: press,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.all(Radius.circular(50.0)),
              // ),
              child: textContext(context),
            ),
    );
  }

  Text textContext(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: kButtonTextStyle,
    );
  }
}
