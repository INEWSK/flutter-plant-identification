import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/form_field_validator.dart';
import 'package:flutter_hotelapp/screen/common_widgets/primary_button.dart';

class ForgotForm extends StatefulWidget {
  @override
  _ForgotFormState createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final _formKey = GlobalKey<FormState>();

  get kTextFieldPadding => null;

  String _email;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // email field
          TextFormField(
            enabled: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: emailValidator,
            onSaved: (value) => _email = value,
            style: kSecondaryBodyTextStyle,
            cursorColor: Colors.teal,
            keyboardType: TextInputType.emailAddress,
            decoration: otpInputDecoration.copyWith(
              prefixIcon: Icon(Icons.person),
              hintText: AppLocalizations.of(context).email,
              contentPadding: kTextFieldPadding,
            ),
          ),
          SizedBox(height: 40),

          // reset button
          PrimaryButton(
            text: AppLocalizations.of(context).resetPassword,
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // test demo
                Navigator.pushReplacementNamed(context, '/emailSent');
              }
            },
          ),
        ],
      ),
    );
  }
}
