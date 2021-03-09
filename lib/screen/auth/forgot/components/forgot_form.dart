import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/form_field_validator.dart';
import 'package:flutter_hotelapp/screen/widgets/primary_button.dart';

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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: emailValidator,
            onSaved: (value) => _email = value,
            style: kSecondaryBodyTextStyle,
            cursorColor: Colors.green,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person),
              hintText: 'Email',
              contentPadding: kTextFieldPadding,
            ),
          ),
          SizedBox(height: 40),

          // reset button
          PrimaryButton(
            text: 'Reset Password',
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
