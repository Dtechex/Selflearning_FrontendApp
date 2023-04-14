import 'dart:convert';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:self_learning_app/features/login/login_screen.dart';
import 'package:self_learning_app/utilities/extenstion.dart';
import 'package:self_learning_app/widgets/auth_button.dart';

import '../../utilities/base_client.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = "/registrationscreen";

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameEditingController = TextEditingController();

  final TextEditingController _emailEditingController = TextEditingController();

  final TextEditingController _phoneNumberEditingController =
      TextEditingController();

  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool isfirsttime = false;

  Future<void> registerUser() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Response decodedresponse = await Api()
          .post(context: context, endPoint: 'user/register', payload: {
        "name": _nameEditingController.text,
        "email": _emailEditingController.text,
        "mobile": "+91${_phoneNumberEditingController.text}",
        "password": _passwordEditingController.text,
      });
      print(decodedresponse.body);
      if (decodedresponse.statusCode == 201) {
        context.showSnackBar(
            const SnackBar(content: Text('Register Successfully')));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
      } else {
        context.showSnackBar(
            const SnackBar(content: Text('Email already exists!')));
      }
    } catch (e) {
      context.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        AppBar().preferredSize.height;
    var w = MediaQuery.of(context).size.width;
    return IgnorePointer(
      ignoring: _isLoading,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Registration'),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: h,
              width: w,
              child: SafeArea(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'New here !',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              'Register to continue',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              width: w,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter valid Name';
                                  }
                                },
                                controller: _nameEditingController,
                                decoration: InputDecoration(hintText: 'Name*'),
                              ),
                            ),
                            SizedBox(
                              width: w,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  bool isValid = EmailValidator.validate(v!);
                                  if (isValid == true) {
                                    return null;
                                  } else {
                                    return 'Enter Valid Email Address';
                                  }
                                },
                                controller: _emailEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Email Address*',
                                  errorStyle: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: w,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "password can't be empty";
                                  }
                                  if (v.length < 6) {
                                    return 'Must be more than 6 character';
                                  }
                                },
                                controller: _passwordEditingController,
                                decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    hintText: "Password*",
                                    fillColor: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: w,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return "Phone Number can't be empty";
                                  }
                                  if (v.length < 10) {
                                    return 'Must 10 digit number';
                                  }
                                },
                                controller: _phoneNumberEditingController,
                                decoration: const InputDecoration(
                                    errorStyle: TextStyle(color: Colors.red),
                                    hintText: "Phone Number",
                                    fillColor: Colors.white),
                              ),
                            ),
                            AuthButton(
                              title: 'Register',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registerUser();
                                } else {
                                  // context.showSnackBar(const SnackBar(
                                  //     content:
                                  //         Text('Please fill correct detail')));
                                }
                              },
                            ),
                          ],
                        ),
                      ))),
            ),
          )),
    );
  }
}
