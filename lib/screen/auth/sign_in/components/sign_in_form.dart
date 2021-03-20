import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';
import 'package:flutter_hotelapp/common/utils/form_field_validator.dart';
import 'package:flutter_hotelapp/common/utils/toast_utils.dart';
import 'package:flutter_hotelapp/provider/auth_provider.dart';
import 'package:flutter_hotelapp/screen/auth/widgets/auth_form_field.dart';
import 'package:flutter_hotelapp/screen/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import 'forgot_button.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  bool _obscureText = true;
  bool _clearButton = false;

  String _email, _password;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _clearButton = _emailController.text.length > 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
  }

  bool _formValidate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _formSubmit() async {
    /// start show loading dialog
    BotToast.showLoading(
      backButtonBehavior: BackButtonBehavior.ignore,
    );

    final response = await Provider.of<AuthProvider>(context, listen: false)
        .signIn(_email, _password);

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
                  ),
          ),
          SizedBox(height: 20),
          // password
          AuthFormField(
              controller: _passwordController,
              maxLength: 20,
              validateMode: _validateMode,
              validator: passwordValidator,
              onSaved: (value) => _password = value,
              onChanged: null,
              inputAction: TextInputAction.done,
              // As of Flutter v1.7.8+hotfix.2, the unfocus way to go is:
              editCompleted: () => FocusScope.of(context).unfocus(),
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
          ForgotButton(),
          SizedBox(height: 20),
          PrimaryButton(
            text: 'Sign In',
            press: () {
              if (_formValidate()) {
                _formSubmit();
                _hideKeyboard();
              } else {
                setState(() {
                  /// if data are not valid then start auto validation.
                  _validateMode = AutovalidateMode.always;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
