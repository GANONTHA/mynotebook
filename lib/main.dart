
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotebook/View/login_view.dart';
import 'package:mynotebook/View/register_view.dart';
import 'package:mynotebook/View/verify_email_view.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void log(String message) {}

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //initializing our db (Firebase)
  runApp(
     MaterialApp(
      title: 'My notebook',
      home: const HomePage(),
      routes: {
        '/login/':(context) => const LoginView(),
        '/register/':(context) => const RegisterView(),
        '/notes/': (context) => const NotesView(),
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

//This Widget is the main UI of our application

enum MenuAction { logout} //Enum

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('My notes'),
        actions: [ 
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  //devtools.log(shouldLogOut.toString());
                  if (shouldLogOut) {
                   await FirebaseAuth.instance.signOut();
                   // ignore: use_build_context_synchronously
                   Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (_) => false,
                   );
                  }
                  break;
                }
            },
            itemBuilder: (context) {
              return const  [
                PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('LogOut'),
                )
              ];
            }
            )
        ],
      ),
      body: const Center(
        child: Text('Hello les gars')
      ),
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