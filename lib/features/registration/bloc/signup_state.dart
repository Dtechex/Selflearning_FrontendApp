import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../login/data/model/email.dart';
import '../data/model/name.dart';
import '../../login/data/model/password.dart';

class SignUpState extends Equatable {
  const SignUpState(
      {this.name = const Name.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.status = FormzStatus.pure,
      this.statusText = '',
      this.passwordObsecure = false,
      this.confrimpasswordObsecure = false});

  final Name name;
  final Email email;
  final Password password;
  final FormzStatus status;
  final String statusText;
  final bool passwordObsecure;
  final bool confrimpasswordObsecure;

  SignUpState copyWith(
      {bool? passwordObsecure,
      bool? confrimpasswordObsecure,
      Name? name,
      Email? email,
      Password? password,
      FormzStatus? status,
      String? statusText}) {
    return SignUpState(
        confrimpasswordObsecure:
            confrimpasswordObsecure ?? this.confrimpasswordObsecure,
        passwordObsecure: passwordObsecure ?? this.passwordObsecure,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        statusText: statusText ?? this.statusText);
  }

  @override
  List<Object> get props =>
      [name, email, password, status, statusText, passwordObsecure,confrimpasswordObsecure];
}
