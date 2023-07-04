
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
               options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
               return Column(
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
                try{
                         final usercredential = 
               await  FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password
                  );
                print(usercredential);
                } on FirebaseAuthException   catch(e){
                  if(e.code == 'user-not-found') {
                    print('USER NOTFPUND');
                  } else if(e.code == 'wrong-password'){
                    print('THE PASSWORD IS NOT CORRECT');
                  } else {
                    print(e.code);
                  }
                }
           
              },
              child: const Text('Login'),
            ),
          ],
        );
        default:
        return const Text('Loading');
          }

        
        },
        
      ),
    );
  }


  
}

