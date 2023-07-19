import 'package:flutter/material.dart';
import 'package:mynotebook/constants/routes.dart';
import 'package:mynotebook/services/auth/auth_exception.dart';
import 'package:mynotebook/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';


class LoginView extends StatefulWidget { //login class. This class is used to login into the app
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
        title: const Text('Login'),
        centerTitle: true,
      ) ,
      body: Column(
            children: [
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
                  hintText: 'Enter your passowrd', 
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
                  
                  
    //Handling Exception on API's call for Firebase Exception
                  try{
                   await AuthService.firebase().login(
                      email: email, 
                      password: password,
                      );
               
                    final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified??false) {
                      //user's email is verified
                      // ignore: use_build_context_synchronously
                       Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute, 
                      (route) => false,
                      );
                    }else {
                      //user's email isn't verified
                       // ignore: use_build_context_synchronously
                       Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, 
                      (route) => false,
                      );
                    }
                  } on UserNotFoundAuthException{
                     await showErrorDialog(context, "USER NOT FOUND",);
                  } on WrongPasswordAuthException {
                    await showErrorDialog(context, "WRONG PASSWORD",);
                  } on GenericAuthException {
                    await showErrorDialog(context, "AUTHENTIFICATION ERROR",);
                  }
                },
                child: const Text('Login'),
              ),
    
      //Button to go to register
              TextButton(
                onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(registerRoute,
                   (route) => false
                   );
                }, 
                child: const Text('Not registered yet? Register here'), //The user will go to Register screen instead if it's her first time
                ),
            ],
          ),
    );
  }
}
