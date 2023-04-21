import 'package:formz/formz.dart';

enum ConfirmPassValidationError { invalid }

class ConfirmPassword extends FormzInput<String, ConfirmPassValidationError> {
  const ConfirmPassword.pure([super.value = '']) : super.pure();
  const ConfirmPassword.dirty([super.value = '']) : super.dirty();

  // static final _passwordRegex =
  // RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');

  @override
  ConfirmPassValidationError? validator(String? value) {
    return value!.length>4
        ? null
        : ConfirmPassValidationError.invalid;
  }
}