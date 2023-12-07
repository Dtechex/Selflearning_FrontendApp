import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:self_learning_app/features/dashboard/dashboard_screen.dart';
import 'package:self_learning_app/features/registration/registration_screen.dart';
import 'package:self_learning_app/utilities/colors.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/utilities/shared_pref.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //  appBar: AppBar(title: const Text('Login')),
        body: SingleChildScrollView(
      child: BlocListener<MyFormBloc, MyFormState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  const DashBoardScreen()), (Route<dynamic> route) => false);
            }
            if (state.status.isSubmissionInProgress) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Loging you in...')),
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
                          const SizedBox(
                            height: 30,
                          ),
                          const EmailInput(),
                          SizedBox(
                            height: context.screenHeight * 0.025,
                          ),
                          const PasswordInput(),
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
                              const Text("Don't have an Account?",style: TextStyle(
                                fontSize: 16
                              ),),
                              TextButton(
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpScreen(),
                                      )),
                                  child: const Text('Sign up',style: TextStyle(
                                      fontSize: 16,fontWeight: FontWeight.bold
                                  ),)),
                            ],
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

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    print(context.screenWidth);
    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {
        print('email state');
        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            //height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                initialValue: state.email.value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  hintText: 'david@gmail.com',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.email,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.06,
                  ),
                  errorText: state.email.invalid
                      ? 'Please ensure the email entered is valid'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  context.read<MyFormBloc>().add(EmailChanged(email: value));
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

    return BlocBuilder<MyFormBloc, MyFormState>(
      builder: (context, state) {

        return Container(
            padding: const EdgeInsets.only(left: 10, right: 5),
            //height: context.screenHeight * 0.1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12)),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                obscureText: !state.isObsecure,
                initialValue: state.password.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        context.read<MyFormBloc>().add(ChangeObsecure(isObsecure: state.isObsecure));
                      },
                      icon: state.isObsecure == false
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  hintText: 'Password',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.lock,
                    size:context.screenWidth>1280?50:context.screenWidth * 0.06,
                  ),
                  errorText: state.password.invalid
                      ? 'Please ensure the Phone Number is valid'
                      : null,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  context
                      .read<MyFormBloc>()
                      .add(PasswordChanged(password: value));
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
    return BlocBuilder<MyFormBloc, MyFormState>(
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
                    .showSnackBar(const SnackBar(content: Text('Invalid password')));
              } else if (state.email.invalid) {
                context.showSnackBar(const SnackBar(content: Text('Invalid Email')));
              }
              SharedPref().clear();
              context.read<MyFormBloc>().add(FormSubmitted());
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
