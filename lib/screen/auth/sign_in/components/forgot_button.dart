import 'package:flutter/material.dart';

class ForgotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/forgot'),
      child: Text(
        'Forgot Password?',
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12.0,
            ),
      ),
    );
  }
}
