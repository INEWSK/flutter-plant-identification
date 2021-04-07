import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CreateAccountButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 12.0),
          text: 'Don\'t have an account? ',
          children: [
            TextSpan(
                text: 'Create a new account',
                style: TextStyle(color: Colors.green),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.pushNamed(context, '/signUp')),
          ],
        ),
      ),
    );
  }
}
