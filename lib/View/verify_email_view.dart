
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotebook/constants/routes.dart';

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
        const Text("We've sent you an email verification please verify your account"),
         const  Text("If you haven't received email verification yet, press the button below"),
          TextButton( 
            onPressed: () async {
                final user = FirebaseAuth.instance.currentUser; //get the current user
                await user?.sendEmailVerification();            //send an Email verification
            },
            child: const Text('Send email Verification'),
          ),
          TextButton(
            onPressed: () async{
             await FirebaseAuth.instance.signOut();
             // ignore: use_build_context_synchronously
             Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
             );
            }, 
            child: const Text('Restart'),
            )
        ]
        ),
    );
  }
}