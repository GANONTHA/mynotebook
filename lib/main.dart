
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotebook/View/login_view.dart';
import 'package:mynotebook/View/register_view.dart';
import 'package:mynotebook/View/verify_email_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized(); //initializing our db (Firebase)
  runApp(
     MaterialApp(
      title: 'My notebook',
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const RegisterView(),
      },
    ));
}


//create the Home page to manage the entire App

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
               options: DefaultFirebaseOptions.currentPlatform,
                ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            if (user.emailVerified) {
              print('Email is verified');
            } else {
              return const VerifyEmailview();
            }
          }else {
            return const LoginView();
          }
          return const Text('Done!');
        default:
        return const CircularProgressIndicator();
          }
        },
      );
  }
}


