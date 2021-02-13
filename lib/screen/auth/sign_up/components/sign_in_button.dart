import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(fontWeight: FontWeight.w500),
          text: 'Already have an account? ',
          children: [
            TextSpan(
              text: 'Sign In',
              style: TextStyle(color: Colors.green),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
