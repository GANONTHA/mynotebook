import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotebook/constants/routes.dart';
import '../utilities/show_error_dialog.dart';


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
                 await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password
                    );
                    final user = FirebaseAuth.instance.currentUser;  //Get the current user
                    await user?.sendEmailVerification();             // sent an email verification
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                } on FirebaseAuthException catch(e){
                  if(e.code == 'weak-password') {
                    await showErrorDialog(context, "The password must have at least 6 characters");
                  } else if(e.code == 'invalid-email') {
                    await showErrorDialog(context, "The email does not Exist");
                  } else if(e.code == 'email-already-in-use') {
                    await showErrorDialog(context, "The email already Registered");
                  } else {
                    await showErrorDialog(context, "Error: ${e.code}",);
                  }
                } catch (e) {
                  await showErrorDialog(context, "Error: ${e.toString()}",);
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

