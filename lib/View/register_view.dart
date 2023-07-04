import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
                try {
              final usercredential = 
               await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password
                  );
                print(usercredential);
             
              } on FirebaseAuthException catch(e){
                if(e.code == 'weak-password') {
                  print('THE PASSWORD MUST HAVE AT LEAST 6 CHARACTERS');
                } else if(e.code == 'invalid-email') {
                  print("THE FORMAT OF YOUR EMAIL IS INCORRECT");
                } else if(e.code == 'email-already-in-use') {
                  print("THE EMAIL IS ALREADY USED BY ANOTHER USER");
                }
              }
              },
              child: const Text('Register'),
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