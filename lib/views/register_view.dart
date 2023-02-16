import 'package:flutter/material.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/services/auth/auth_exceptions.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
              final email = _email.text;
              final password = _password.text;

              try {
                await AuthService.firebase().createUser(
                  email: email, 
                  password: password,
                );

                if(context.mounted){
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }

                // Sending the email verification automatically as soon as the user registers.
                AuthService.firebase().sendEmailVerification();
              }
              on WeakPasswordAuthException{
                  await showErrorDialog(context, 'Weak Password');
              }
              on EmailAlreadyInUseAuthException{
                  await showErrorDialog(context, 'Email is already in use');
              }
              on InvalidEmailAuthException{
                  await showErrorDialog(context, 'Invalid Email Entered');
              }
              on GenericAuthExceptions{
                  await showErrorDialog(context, 'Authentication Error: Failed to register');
              }
            },

            child: const Text('Register'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here'),
          ),
        ],
      ),
    );
  }
}
