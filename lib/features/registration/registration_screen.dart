import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:self_learning_app/features/registration/bloc/signup_bloc.dart';
import 'package:self_learning_app/features/registration/bloc/signup_event.dart';
import 'package:self_learning_app/features/registration/bloc/signup_state.dart';
import 'package:self_learning_app/features/registration/registration_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';

import '../login/bloc/login_event.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(title: const Text('Login')),
        body: SingleChildScrollView(
          child: BlocListener<SignUpBloc, SignUpState>(
              listener: (context, state) {
                if (state.status.isSubmissionSuccess) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('SignUp Successfully....')),
                    );
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      const LoginScreen()), (Route<dynamic> route) => false);
                }
                if (state.status.isSubmissionInProgress) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text('Please wait....')),
                    );
                }
                if (state.status.isSubmissionFailure) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  showDialog<void>(
                    context: context,
                    builder: (_) => SuccessDialog(dailogText: state.statusText),
                  );
                }
              },
              child: Container(
                color: primaryColor,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: primaryColor,
                          height: context.screenHeight * 0.18,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: context.screenHeight * 0.1,
                              ),
                              const Text(
                                'Login with Email ID',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: context.screenHeight * 0.02,
                              ),
                              const Text(
                                'Please login to continue using our app.',
                                style: TextStyle(
                                    color: Colors.black,
                                    // height: 1.5,
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: context.screenHeight * 0.025,
                              ),
                              const NameInput(),
                              SizedBox(
                                height: context.screenHeight * 0.025,
                              ),
                              const EmailInput(),
                              SizedBox(
                                height: context.screenHeight * 0.025,
                              ),
                              const PasswordInput(),
                              SizedBox(
                                height: context.screenHeight * 0.025,
                              ),
                              const ConfirmPasswordInput(),
                              SizedBox(
                                height: context.screenHeight * 0.05,
                              ),
                              const SubmitButton(),
                              SizedBox(
                                height: context.screenHeight * 0.03,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Already have an Account?',style: TextStyle(
                                      fontSize: 16
                                  ),),
                                  TextButton(
                                      child: const Text('Sign In',style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),),
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                            LoginScreen()), (Route<dynamic> route) => false);
                                      }
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: context.screenHeight * 0.07,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        left: context.screenWidth / 2.75,
                        top: context.screenHeight * 0.12,
                        child: Container(
                            height: context.screenHeight * 0.14,
                            width: context.screenWidth / 3.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                              child: Text('    Self \nLearning',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                            ))),
                  ],
                ),
              )),
        ));
  }
}

class NameInput extends StatelessWidget {
  const NameInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                initialValue: state.email.value,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.account_circle_outlined,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.08,
                  ),
                  errorText: state.email.invalid
                      ? 'Please ensure the name entered is valid'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<SignUpBloc>().add(SignUpNameChanged(name: value));
                },
                textInputAction: TextInputAction.next,
              ),
            ));
      },
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                initialValue: state.email.value,
                decoration: InputDecoration(
                  hintText: 'david@gmail.com',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.email,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.08,
                  ),
                  errorText: state.email.invalid
                      ? 'Please ensure the email entered is valid'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<SignUpBloc>().add(SignUpEmailChanged(email: value));
                },
                textInputAction: TextInputAction.next,
              ),
            ));
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
  });
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {

        print(state.password);
        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                obscureText: !state.passwordObsecure,
                initialValue: state.password.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        context.read<SignUpBloc>().add(PassObsecure(passwordObsecure: state.passwordObsecure));
                      },
                      icon: state.passwordObsecure == false
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  hintText: 'Password',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.lock,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.08,
                  ),
                  errorText: state.password.invalid
                      ? 'Please ensure password is valid'
                      : null,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  context
                      .read<SignUpBloc>()
                      .add(SignUpPasswordChanged(password: value));
                },
                textInputAction: TextInputAction.next,
              ),
            ));
      },
    );
  }
}

class ConfirmPasswordInput extends StatelessWidget {
  const ConfirmPasswordInput({
    super.key,
  });
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {

        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                obscureText: !state.confrimpasswordObsecure,
                initialValue: state.password.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        context.read<SignUpBloc>().add(ConfrimPassObsecure(confirmpassword : state.confrimpasswordObsecure));
                      },
                      icon: state.confrimpasswordObsecure == false
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
                  hintText: 'Confrim Password',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.lock,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.08,
                  ),
                  errorText: state.password.invalid
                      ? 'password and confrim password must be same'
                      : null,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  context
                      .read<SignUpBloc>()
                      .add(SignUpPasswordChanged(password: value));
                },
                textInputAction: TextInputAction.next,
              ),
            ));
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return SizedBox(
          height: context.screenHeight * 0.08,
          width: context.screenWidth,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.grey)))),
            onPressed: () {
              if (state.password.invalid) {
                context
                    .showSnackBar(SnackBar(content: Text('Invalid password')));
              } else if (state.email.invalid) {
                context.showSnackBar(SnackBar(content: Text('Invalid Email')));
              }
              context.read<SignUpBloc>().add(SignUpFormSubmitted());
            },
            child: const Text(
              'Login',
              style: TextStyle(fontSize: 22),
            ),
          ),
        );
      },
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String dailogText;

  const SuccessDialog({super.key, required this.dailogText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      dailogText,
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// 008869