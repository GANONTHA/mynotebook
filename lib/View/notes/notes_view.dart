import 'package:flutter/material.dart';
import 'package:mynotebook/View/notes/notes_list_view.dart';
import 'package:mynotebook/services/auth/auth_service.dart';
import 'package:mynotebook/services/crud/notes_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
late final NoteService _notesService;
//get the user email
String get userEmail => AuthService.firebase().currentUser!.email!;
@override
  void initState() {
    _notesService = NoteService();
  //  _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
        title: const Text('My Notes'),
        actions: [ 
          IconButton(
            onPressed: () { 
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            }, 
            icon: const Icon(Icons.add)
            ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                  final shouldLogOut = await showLogOutDialog(context);
                  
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot){ 
          switch (snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                      return NotesListView(
                        notes: allNotes, 
                        onDeleteNote: (note) async{   //function to delete the item when user click on the icon
                          await _notesService.deleteNote(id: note.id);
                        },
                        onTap: (note) {   //To update the item when user click on an existing note
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                            );
                        },
                        );
                      }else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                }
                );
            default:
            return const CircularProgressIndicator();
            
          } 
        },
      ),
    );
  }
}