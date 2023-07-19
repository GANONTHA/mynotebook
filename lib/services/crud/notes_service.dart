import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mynotebook/extensions/list/filter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'crudexception.dart';


class NoteService {
  Database? _db;

List<DatabaseNote> _notes = [];
DatabaseUser? _user;

static final NoteService _shared = NoteService._shardInstance();
NoteService._shardInstance() {
  _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
    onListen: () {
      _notesStreamController.sink.add(_notes);
    },
  );
}
factory NoteService() => _shared;
late final StreamController<List<DatabaseNote>> _notesStreamController;

Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream.filter((note) {
  final currentUser = _user;
  if (currentUser != null) {
    return note.userId == currentUser.id;
  } else {
    throw UserShouldBeSetBeforeReadingAllNotes();
  }
}
);
Future<DatabaseUser> getOrCreateUser({required String email, bool setAsCurrentUer = true}) async{
  try {
    final user = await getUser(email: email);
    if (setAsCurrentUer){
      _user = user;
    }
    
    return user;
    } on CouldNotFindUser {
      final createdUser = await createUser(email: email);
      if(setAsCurrentUer) {
        _user = createdUser;
      }
      return createdUser;
    } catch(e) {
      rethrow;
    }
}
Future<void> _cacheNotes() async{
  final allNotes = await getAllNotes();
  _notes = allNotes.toList();
  _notesStreamController.add(_notes);
  }
Future<DatabaseNote> updateNote({
  required DatabaseNote note, required String text, }) async {
    await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();

  //Making sure the note exists
   await getNote(id: note.id);

   //update DB
  final updatesCount =  await db.update(noteTable, {
    textColumn: text,
    isSyncedWithCloudColumn: 0,
  }, where: 'id = ?', whereArgs: [note.id],
  );

if(updatesCount ==0) {
  throw CouldNotUpdateNote();
}else {
  final updatedNote =  await getNote(id: note.id);
  _notes.removeWhere((note) => note.id == updatedNote.id);
  _notes.add(updatedNote);
  _notesStreamController.add(_notes);
  return updatedNote;
}
  
}
Future<Iterable<DatabaseNote>> getAllNotes() async{
  await _ensureDbIsOpen();
   final db = _getDatabaseOrThrow();
  final notes = await db.query(
  noteTable, 
  );
return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));


  }
Future<DatabaseNote> getNote({required int id}) async{
  await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();
  final notes = await db.query(
  noteTable, 
  limit: 1, 
  where: 'id = ?', 
  whereArgs: [id],
  );

  if(notes.isEmpty) {
    throw CouldNotFindNote();
  }else {
    final note =  DatabaseNote.fromRow(notes.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }
}
Future<int> deleteAllNotes() async {
  await _ensureDbIsOpen();
  final db= _getDatabaseOrThrow();
  final numberOfDeletions =  await db.delete(noteTable);
  _notes = [];
  _notesStreamController.add(_notes);
  return numberOfDeletions;
}
Future<void> deleteNote({required int id}) async {
  await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();
  final  deleteCount = await db.delete(
    noteTable, 
    where:  'id = ?', 
    whereArgs: [id],
    );
    // ignore: unrelated_type_equality_checks
    if(deleteCount == 0) {
      throw CouldNotDeleteNote();
    }else {
      //making sure our cache is updated
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
}
Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
  await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();
//making sure the owner exists in the  databse witht the current email
  final dbUser = await getUser(email: owner.email);
  if(dbUser != owner) {
    throw CouldNotFindUser();
  }

  const text = '';
  //create the note
  final noteId = await db.insert(noteTable, {
    userIdColumn: owner.id,
    textColumn: text,
    isSyncedWithCloudColumn: 1,
  });

  final note = DatabaseNote(id: noteId, 
  isSyncedWithCloud: true, 
  text: text, 
  userId: owner.id,
  );

  _notes.add(note);
  _notesStreamController.add(_notes);
  return note;
}
Future<DatabaseUser> getUser({required String email}) async{
  await _ensureDbIsOpen();
final db = _getDatabaseOrThrow();
  final result = await db.query(
    userTable, 
    limit: 1, where:  'email = ?', 
    whereArgs: [email.toLowerCase()],
    );
if(result.isEmpty) {
  throw CouldNotFindUser();
}else {
  return DatabaseUser.fromRow(result.first);
}
}
Future<DatabaseUser> createUser ({required String email}) async{
  await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();
  final result = await db.query(
    userTable, 
    limit: 1, where:  'email = ?', 
    whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExits();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase()
    });
    return DatabaseUser(id: userId, email: email);
}
Future<void> deleteUser({required String email}) async {
  await _ensureDbIsOpen();
  final db = _getDatabaseOrThrow();
  final  deleteCount = await db.delete(
    userTable, 
    where:  'email = ?', 
    whereArgs: [email.toLowerCase()],
    );
    // ignore: unrelated_type_equality_checks
    if(deleteCount != 1) {
      throw CouldNoteDeleteUser();
    }
}
  Database _getDatabaseOrThrow () {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    }else {
      return db;
    }
  }
  Future<void> close() async {
    final db = _db;
    if(db == null) {
      throw DatabaseAlreadyOpendException();
    }else {
      await db.close();
      _db == null;
    }
  }
  Future<void> _ensureDbIsOpen() async{
    try {
      await open();
    } on DatabaseAlreadyOpendException {
      //empty;
    }
  }
  Future<void> open () async {
    if (_db != null) {
      throw DatabaseAlreadyOpendException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbpath = join(docsPath.path,dbName);
      final db = await openDatabase(dbpath);
      _db = db;

  //create user table   
await db.execute(createUserTable);

//create user table
await db.execute(createNoteTable);

//caching all the notes
await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
      required this.email,
      required this.id,
    });
    DatabaseUser.fromRow(Map<String, Object?> map) : id = map[idColumn] as int,
    email = map[emailColumn] as String;

    @override
  String toString() => 'Person, ID = $id, email = $email';


  @override bool operator == (covariant DatabaseUser other) => id == other.id;
  
  @override
  
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final String text ;
  final int id;
  final int userId;
  final bool isSyncedWithCloud;

  DatabaseNote( 
    {
      required this.id,
      required this.isSyncedWithCloud,
      required this.text,
      required this.userId,
    });

     DatabaseNote.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
    userId = map[userIdColumn] as int,
    text = map[textColumn] as String,
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1? true:false;

    @override
  String toString() => 'Note, ID = $id, $userId, isSyncedWithClound = $isSyncedWithCloud, text = $text';
   @override bool operator == (covariant DatabaseNote other) => id == other.id;
  
  @override
  
  int get hashCode => id.hashCode;

}

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';

//create our user table
 const createUserTable = '''
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

//Creating the Note table
const createNoteTable = '''
CREATE TABLE IF NOT EXISTS "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);
''';