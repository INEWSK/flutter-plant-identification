import 'package:form_field_validator/form_field_validator.dart';

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address'),
]);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  // PatternValidator(r'(?=.*?[A-Z])',
  //     errorText: 'Must have at least one uppercase character'),
  PatternValidator(r'(?=.*?[0-9])', errorText: 'Must have at least one number')
]);

final requiredValidator =
    RequiredValidator(errorText: 'This field is required');

final matchValidator = MatchValidator(errorText: 'Passwords do not match');
