import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safarnama/constants.dart';
import 'package:safarnama/services/authentication_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loginFormLoading = false;

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
              TextButton(
                child: Text(
                  "Close",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
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
      _loginFormLoading = true;
    });

    // Login Account
    String _loginFeedback = await context.read<AuthenticationService>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

    // If the string is not null, we got error while create account.
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  void _googleSignIn() async {
    setState(() {
      _loginFormLoading = true;
    });
    String _loginFeedback =
        await context.read<AuthenticationService>().signInWithGoogle();
    if (_loginFeedback != null) {
      print(_loginFeedback);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(_loginFeedback),
      ));
    }
    setState(() {
      _loginFormLoading = false;
    });
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 132.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Welcome,\n',
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 54.0,
                      ),
                      children: [
                        TextSpan(
                            text: 'sign-in.',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary))
                      ]),
                ),
                SizedBox(
                  height: 88.0,
                ),
                TextField(
                  autocorrect: false,
                  controller: _emailController,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Theme.of(context).disabledColor),
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
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextField(
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: Theme.of(context).colorScheme.secondary,
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Theme.of(context).disabledColor),
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
                        color: Theme.of(context).colorScheme.secondary,
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
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 72.0, vertical: 12.0),
                          child: _loginFormLoading
                              ? Container(
                                  height: 26.0,
                                  width: 26.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                    backgroundColor: Colors.white,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                )
                              : Text(
                                  "Login",
                                  style: buttonText,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 54.0),
                        child: GestureDetector(
                          onTap: () async {
                            _googleSignIn();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Or sign-in with ',
                                style: greyText.copyWith(fontSize: 18.0),
                              ),
                              Icon(
                                FontAwesomeIcons.google,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: RichText(
                          text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: greyText,
                              children: [
                                TextSpan(
                                    text: 'Sign up.',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
