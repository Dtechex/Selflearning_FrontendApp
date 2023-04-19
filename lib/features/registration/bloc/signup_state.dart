import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../login/data/model/email.dart';
import '../data/model/name.dart';
import '../../login/data/model/password.dart';

class SignUpState extends Equatable {
  const SignUpState({ this.name= const Name.pure(),
        this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.status = FormzStatus.pure,
      this.statusText = ''});

  final Name name;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String statusText;

  SignUpState copyWith(
      {
        Name? name,
        Email? email,
      Password? password,
      FormzStatus? status,
      String? statusText}) {
    return SignUpState(
      name: name??this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        statusText: statusText ?? this.statusText);
  }

  @override
  List<Object> get props => [name,email, password, status, statusText];
}
