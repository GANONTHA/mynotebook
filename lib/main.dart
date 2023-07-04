
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotebook/View/login_view.dart';
import 'package:mynotebook/View/register_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); //initializing our db (Firebase)
  runApp(const MaterialApp(
      title: 'My notebook',
      home: HomePage(),
    ));
}


//create the Home page to manage the entire App

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
               options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            
            // final user = FirebaseAuth.instance.currentUser;
  
            // if (user?.emailVerified ?? false) {
            //   print('THIS EMAIL IS GOOD TO GO');
            //   return const Text('Done');
            // } else {
            //   return  const VerifyEmailview();
            // }
        default:
        return const LoginView();
          }
        },
      ),
    );
  }


}

class VerifyEmailview extends StatefulWidget {
  const VerifyEmailview({super.key});

  @override
  State<VerifyEmailview> createState() => _VerifyEmailviewState();
}

class _VerifyEmailviewState extends State<VerifyEmailview> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
       const  Text('Please verify your email'),
        TextButton( 
          onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
          },
          child: const Text('Send email Verification'),
        )
      ]
      );
  }
}