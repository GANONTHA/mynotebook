import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotebook/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';
import '../main.dart';

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
                   await AuthService.firebase().logOut();
                   // ignore: use_build_context_synchronously
                   Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
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