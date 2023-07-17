import 'package:flutter/material.dart';
import 'package:mynotebook/View/login_view.dart';
import 'package:mynotebook/View/notes/new_note_view.dart';
import 'package:mynotebook/View/register_view.dart';
import 'package:mynotebook/View/verify_email_view.dart';
import 'package:mynotebook/constants/routes.dart';
import 'package:mynotebook/services/auth/auth_service.dart';
import 'View/notes/notes_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //initializing our db (Firebase)
  runApp(
     MaterialApp(
      title: 'My notebook',
      home: const HomePage(),
      routes: {
        loginRoute:(context) => const LoginView(),
        registerRoute:(context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailview(),
        newNoteRoute: (context) => const NewNoteView(),
      },
    ));
}


//create the Home page to manage the entire App

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
          final user =  AuthService.firebase().currentUser;
          if (user != null) {
            if (user.isEmailVerified) {
              return const NotesView();
            } else {
              return const VerifyEmailview();
            }
          }else {
            return const LoginView();
          }
        default:
        return const CircularProgressIndicator();
          }
        },
      );
  }
}


Future<bool> showLogOutDialog (BuildContext context) {
 return showDialog<bool>(
    context: context, 
    builder:(context) {
      return AlertDialog( 
        title: const Text('Sign Out here'),
        content: const Text('Are sure you want to sign out ?'),
        actions: [ 
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            }, 
            child: const Text('Cancel'),
            ),
              TextButton(
            onPressed: () {
            Navigator.of(context).pop(true);
            }, 
            child: const Text('Log Out'),
            ),
        ],
      );
    },
    ).then((value) => value ?? false);
}