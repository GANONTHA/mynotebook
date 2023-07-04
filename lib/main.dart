import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {
  runApp(const MaterialApp(
      title: 'My notebook',
      home: HomePage(),
    ));
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            decoration: const InputDecoration(hintText: 'Enter your email', enabled: true
            ),
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your passowrd',  labelText: "Password"), 
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
            final usercredential = 
             await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email,
                password: password
                );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

