import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotebook/services/auth/auth_exception.dart';
import 'package:mynotebook/services/auth/bloc/auth_bloc.dart';
import 'package:mynotebook/services/auth/bloc/auth_event.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  //class to register new user
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
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateRegistering) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(context, 'Weak-Password');
            } else if (state.exception is EmailAlreadyInUseAuthException) {
              await showErrorDialog(context, 'Email already in use');
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(context, 'Failed to register');
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(context, 'Invalid email');
            }
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your credentials to create your account'),
                  Column(
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          labelText: 'Email',
                        ),
                      ),
                      TextField(
                        controller: _password,
                        decoration: const InputDecoration(
                            hintText: 'Enter your passowrd',
                            labelText: "Password"),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          //Handle Exception on API call for Firebase Exception
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
                        },
                        child: const Text('Register'),
                      ),
                      //Button to go to register
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                        },
                        child: const Text(
                          'Already registered? SignIn here',
                        ), //The user will go to Register screen instead if it's her first time
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
