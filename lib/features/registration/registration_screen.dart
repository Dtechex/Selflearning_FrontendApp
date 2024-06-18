import 'package:blurrycontainer/blurrycontainer.dart';
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
    return  Scaffold(
      backgroundColor: primaryColor,
      //  appBar: AppBar(title: const Text('Login')),
        body: Stack(
          children:
         [
           Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 8),
                 child: BlurryContainer(
                   padding: EdgeInsets.symmetric(horizontal: 8),

                   blur: 5,
                   color: Colors.grey.shade100.withOpacity(0.5),
                   elevation: 10,
                   width: double.infinity,
                   child: Column(
                     children: [
                       SizedBox(height: 50,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Text("SignUp", style: TextStyle(color: Colors.indigoAccent,
                           fontSize: 25,
                             letterSpacing: 1,
                             fontWeight: FontWeight.w500
                           ),),
                         ],
                       ),
                       SizedBox(height: 50,),
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
                       Text('Already have an Account?',style: TextStyle(
                           fontSize: 16
                       ),),
                       TextButton(
                           child: const Text('Sign In',style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 16
                           ),),
                           onPressed: () {
                             Navigator.pop(context);

                           }
                       ),
                     ],
                   ),

                 ),
               ),

             ],
           ),
           Positioned(
             top: MediaQuery.of(context).size.height*0.14,
             left: MediaQuery.of(context).size.width*0.3,
             right: MediaQuery.of(context).size.width*0.3,
             height: 100, // Height inside BlurryContainer
             child: BlurryContainer(
               elevation: 10,
               blur: 6,
               color: Colors.grey.shade100.withOpacity(0.5),
               child: Center(
                 child: Text(
                   'Savant',
                   style: TextStyle(fontSize: 24, color: primaryColor),
                 ),
               ),
             ),
           ),
         ]

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

            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey)
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                initialValue: state.email.value,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.account_circle_outlined,
                    color: primaryColor,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.06,                  ),
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
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey)
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                initialValue: state.email.value,
                decoration: InputDecoration(
                  hintText: 'david@gmail.com',
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.email,
                    color: primaryColor,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.06,                  ),
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
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1, color: Colors.grey)
            ),
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
                    color: primaryColor,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.06,                  ),
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
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey)
            ),
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
                    color: primaryColor,
                    size: context.screenWidth>1280?50:context.screenWidth * 0.06,
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
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
              'Sign Up',
              style: TextStyle(fontSize: 18),
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