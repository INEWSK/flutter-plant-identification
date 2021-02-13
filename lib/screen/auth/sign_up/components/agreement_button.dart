import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AgreementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontWeight: FontWeight.w500),
          text: 'By Signing up you agree to our ',
          children: [
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(color: Colors.green),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, '/agreement'),
            ),
          ],
        ),
      ),
    );
  }
}
