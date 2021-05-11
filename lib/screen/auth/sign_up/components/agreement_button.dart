import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgreementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 12.0),
          text: AppLocalizations.of(context).agreeText + ' ',
          children: [
            TextSpan(
              text: AppLocalizations.of(context).terms,
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
