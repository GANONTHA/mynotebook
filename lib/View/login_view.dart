import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotebook/services/auth/auth_exception.dart';
import 'package:mynotebook/services/auth/bloc/auth_bloc.dart';
import 'package:mynotebook/services/auth/bloc/auth_event.dart';
import 'package:mynotebook/services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  //login class. This class is used to login into the app
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find a user with the enterred credentials');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong-Credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authentification-Error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Please log into your account with your credentials'),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  //labelText: 'Email',
                ),
              ),
              TextField(
                controller: _password,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                  // labelText: "Password",
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
              ),

              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(email: ''),
                      );
                },
                child: const Text('I forgot my passoword'),
              ),

              //Button to go to register
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());
                },
                child: const Text(
                    'Not registered yet? Register here'), //The user will go to Register screen instead if it's her first time
              ),
            ],
          ),
        ),
      ),
    );
  }
}
