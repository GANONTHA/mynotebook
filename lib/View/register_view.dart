import 'package:flutter/material.dart';
import 'package:mynotebook/constants/routes.dart';
import 'package:mynotebook/services/auth/auth_exception.dart';
import 'package:mynotebook/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';



class RegisterView extends StatefulWidget { //class to register new user
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
    _password= TextEditingController();
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
        centerTitle: true,
      ),
       body: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
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
                  try {
                 await  AuthService.firebase().createUser(
                    email: email,
                    password: password
                    );
          
                await AuthService.firebase().sendEmailVerification();          // sent an email verification
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, "The password must have at least 6 characters");
                } on InvalidEmailAuthException {
                   await showErrorDialog(context, "The email does not Exist");
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, "The email already Registered");
                } on GenericAuthException {
                  await showErrorDialog(context, "AUTHENTIFICATION ERROR",);
                }
                },
                child: const Text('Register'),
              ),
                //Button to go to register
            TextButton(
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute,
                 (route) => false
                 );
              }, 
              child: const Text('Already registered? SignIn here'), //The user will go to Register screen instead if it's her first time
              ),
            ],
          ),
     );
  }
}

