import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import 'crudexception.dart';




class NoteService {
  Database? _db;
Future<DatabaseNote> updateNote({required DatabaseNote note, required String text, }) async {
  final db = _getDatabaseOrThrow();
   await getNote(id: note.id);
  final updatesCount =  await db.update(noteTable, {
    textColumn: text,
    isSyncedWithCloudColumn: 0,
  });

if(updatesCount ==0) {
  throw CouldNotUpdateNote();
}else {
  return await getNote(id: note.id);
}
  
}
Future<Iterable<DatabaseNote>> getAllNotes() async{
   final db = _getDatabaseOrThrow();
  final notes = await db.query(
  noteTable, 
  );
return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));


  }
Future<DatabaseNote> getNote({required int id}) async{
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
    return DatabaseNote.fromRow(notes.first);
  }
}
Future<int> deleteAllNotes() async {
  final db= _getDatabaseOrThrow();
  return await db.delete(noteTable);
}
Future<void> deleteNote({required int id}) async {
  final db = _getDatabaseOrThrow();
  final  deleteCount = await db.delete(
    noteTable, 
    where:  'id = ?', 
    whereArgs: [id],
    );
    // ignore: unrelated_type_equality_checks
    if(deleteCount == 0) {
      throw CouldNotDeleteNote();
    }
}
Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
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

  return note;
}
Future<DatabaseUser> getUser({required String email}) async{
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
  final db = _getDatabaseOrThrow();
  final result = await db.query(
    userTable, 
    limit: 1, where:  'email = ?', 
    whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw UserAlreadyExits();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase()
    });
    return DatabaseUser(id: userId, email: email);
}
Future<void> deleteUser({required String email}) async {
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
const isSyncedWithCloudColumn = 'is_synced_with-coud';
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
CREATE TABLE IF NOT EXISTS"notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"is_synced_with_cloud"	INTEGER DEFAULT 0,
	PRIMARY KEY("id"),
	FOREIGN KEY("user_id") REFERENCES "user"("id")
);
''';