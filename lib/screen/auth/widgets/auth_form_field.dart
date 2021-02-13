import 'package:flutter/material.dart';
import 'package:flutter_hotelapp/common/styles/styles.dart';

class AuthFormField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLength;
  final AutovalidateMode validateMode;
  final Function validator;
  final Function onSaved;
  final Function onChanged;
  final TextInputAction inputAction;
  final VoidCallback editCompleted;
  final TextInputType inputType;
  final bool obscureText;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;

  const AuthFormField(
      {Key key,
      this.controller,
      this.maxLength,
      @required this.validateMode,
      @required this.validator,
      @required this.onSaved,
      @required this.onChanged,
      @required this.inputAction,
      @required this.editCompleted,
      @required this.inputType,
      @required this.obscureText,
      @required this.hintText,
      @required this.prefixIcon,
      @required this.suffixIcon})
      : super(key: key);

  get kTextFieldPadding => null;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      buildCounter: (BuildContext context,
              {int currentLength, int maxLength, bool isFocused}) =>
          null,
      autovalidateMode: validateMode,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      textInputAction: inputAction,
      onEditingComplete: editCompleted,
      obscureText: obscureText,
      keyboardType: inputType,
      style: kInputTextStyle,
      // cursorColor: AppColor.active_color,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        contentPadding: kTextFieldPadding,
        border: kDefaultOutlineInputBorder,
        enabledBorder: kDefaultOutlineInputBorder,
        focusedBorder: kDefaultOutlineInputBorder,
        errorBorder:
            kDefaultOutlineInputBorder.copyWith(borderSide: kErrorBorderSide),
        focusedErrorBorder: kDefaultOutlineInputBorder.copyWith(
          borderSide: kErrorBorderSide,
        ),
      ),
    );
  }
}
