// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';
// import '../utilities/show_error_dialog.dart';
// import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here.'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: 'Enter your password here.'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );

                // Code to check whether the user's email is verified or not
                final user = FirebaseAuth.instance.currentUser;
                if (user?.emailVerified ?? false) {
                  // User's email is Verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  }
                }else{
                  // User's email is NOT Verified
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                }

              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  // devtools.log("User Not Found");
                  await showErrorDialog(context, 'User Not Found');
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(context, 'Wrong Credentials');
                } else {
                  await showErrorDialog(context, 'Error: ${e.code}');
                }
              } catch (e) {
                // devtools.log("Something bad happened");
                // devtools.log(e.runtimeType.toString());
                // devtools.log(e.toString());
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/register/',
                  (route) => false,
                );
              },
              child: const Text('Not registered yet? Register here!')),
        ],
      ),
    );
  }
}
