import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/forgot'),
      child: Text(
        AppLocalizations.of(context).forgotPassword,
        style: Theme.of(context).textTheme.button.copyWith(
              fontSize: 12.0,
            ),
      ),
    );
  }
}
