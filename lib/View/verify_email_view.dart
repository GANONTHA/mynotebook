
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailview extends StatefulWidget {
  const VerifyEmailview({super.key});

  @override
  State<VerifyEmailview> createState() => _VerifyEmailviewState();
}

class _VerifyEmailviewState extends State<VerifyEmailview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your Email'),
        centerTitle: true,
      ),
      body: Column(children: [
         const  Text('Please verify your email'),
          TextButton( 
            onPressed: () async {
                final user = FirebaseAuth.instance.currentUser; //get the current user
                await user?.sendEmailVerification();            //send an Email verification
            },
            child: const Text('Send email Verification'),
          )
        ]
        ),
    );
  }
}