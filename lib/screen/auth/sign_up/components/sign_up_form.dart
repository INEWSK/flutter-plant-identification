import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/form_field_validator.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/auth_form_field.dart';
import 'package:flutter_hotelapp/screen/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import 'agreement_button.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  bool _obscureText = true;
  bool _clearButton = false;

  String _email, _password, _confirmPassword;

  Map response = Map();

  @override
  void initState() {
    super.initState();
    // text field listener
    _emailController.addListener(() {
      setState(() {
        _clearButton = _emailController.text.length > 0;
      });
    });
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  bool _formValidate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _formSubmit() async {
    /// start show loading dialog
    BotToast.showLoading(
      backButtonBehavior: BackButtonBehavior.ignore,
    );

    /// call provider process sign up method
    response = await Provider.of<AuthProvider>(context, listen: false)
        .signUp(_email, _password, _confirmPassword);

    BotToast.closeAllLoading();

    final String message = response['message'];
    final bool success = response['success'];

    if (success) {
      Toast.show(message);
      Navigator.pop(context);
    } else {
      BotToast.showNotification(
        title: (_) => Text(
          message,
          style: kBodyTextStyle.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      );
    }
  }

  void _hideKeyboard() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // email
          AuthFormField(
              controller: _emailController,
              maxLength: 30,
              validateMode: _validateMode,
              validator: emailValidator,
              onSaved: (value) => _email = value,
              onChanged: null,
              inputAction: TextInputAction.next,
              editCompleted: () => FocusScope.of(context).nextFocus(),
              inputType: TextInputType.emailAddress,
              obscureText: false,
              hintText: 'Email',
              prefixIcon: Icon(Icons.person),
              suffixIcon: (!_clearButton)
                  ? null
                  : GestureDetector(
                      onTap: () => _emailController.clear(),
                      child: Icon(Icons.clear),
                    )),
          SizedBox(height: 20),
          // password
          AuthFormField(
              maxLength: 20,
              validateMode: _validateMode,
              validator: passwordValidator,
              // for validate password
              onChanged: (value) => _password = value,
              onSaved: (value) => _password = value,
              inputAction: TextInputAction.next,
              // As of Flutter v1.7.8+hotfix.2, the unfocus way to go is:
              editCompleted: () => FocusScope.of(context).nextFocus(),
              inputType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )),
          SizedBox(height: 20),
          // confirm password
          AuthFormField(
              maxLength: 20,
              validateMode: _validateMode,
              validator: (value) =>
                  matchValidator.validateMatch(value, _password),
              onSaved: (value) => _confirmPassword = value,
              onChanged: null,
              inputAction: TextInputAction.done,
              editCompleted: () => FocusScope.of(context).unfocus(),
              inputType: TextInputType.visiblePassword,
              obscureText: _obscureText,
              hintText: 'Re-enter Password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: _obscureText
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )),
          SizedBox(height: 15),
          AgreementButton(),
          SizedBox(height: 20),
          PrimaryButton(
            text: 'Sign Up',
            press: () {
              if (_formValidate()) {
                _formSubmit();
                _hideKeyboard();
              } else {
                setState(() {
                  _validateMode = AutovalidateMode.always;
                });
              }
            },
          )
        ],
      ),
    );
  }
}
