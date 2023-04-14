import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../data/model/email.dart';
import '../data/model/password.dart';

class MyFormState extends Equatable {
  const MyFormState({this.email = const Email.pure(), this.password = const Password.pure(), this.status = FormzStatus.pure,
      this.statusText = ''});

  final Email email;
  final Password password;
  final FormzStatus status;
  final String statusText;

  MyFormState copyWith({
    Email? email,
    Password? password,
    FormzStatus? status,
    String? statusText
  }) {
    return MyFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      statusText: statusText??this.statusText
    );
  }

  @override
  List<Object> get props => [email, password, status,statusText];
}
