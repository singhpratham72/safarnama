import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/services/authentication_service.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _signUpFormLoading = false;

  // Dialog box to show alerts
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "Close",
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Executes when the login button is pressed
  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _signUpFormLoading = true;
    });

    // Login Account
    String _signUpFeedback = await context.read<AuthenticationService>().signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim());

    // If the string is not null, we got error while create account.
    if (_signUpFeedback != null) {
      _alertDialogBuilder(_signUpFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _signUpFormLoading = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: 'Create your\n',
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontSize: 54.0,
                  ),
                  children: [
                    TextSpan(
                        text: 'account.',
                        style: TextStyle(color: Theme.of(context).accentColor))
                  ]),
            ),
            SizedBox(
              height: 54.0,
            ),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                labelText: "Name",
                filled: true,
                fillColor: Theme.of(context).dialogBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                labelText: "Phone",
                filled: true,
                fillColor: Theme.of(context).dialogBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                labelText: "E-mail",
                filled: true,
                fillColor: Theme.of(context).dialogBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              cursorColor: Theme.of(context).accentColor,
              decoration: InputDecoration(
                labelText: "Password",
                filled: true,
                fillColor: Theme.of(context).dialogBackgroundColor,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _submitForm();
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      alignment: Alignment.center,
                      height: 48.0,
                      width: MediaQuery.of(context).size.width / 1.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Theme.of(context).accentColor,
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 96.0, vertical: 12.0),
                      child: _signUpFormLoading
                          ? Container(
                              height: 26.0,
                              width: 26.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                                backgroundColor: Colors.white,
                              ),
                            )
                          : Text(
                              "Sign Up",
                              style: buttonText,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: TextSpan(
                          text: 'Already have an account? ',
                          style: greyText,
                          children: [
                            TextSpan(
                                text: 'Log in.',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Theme.of(context).accentColor))
                          ]),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
