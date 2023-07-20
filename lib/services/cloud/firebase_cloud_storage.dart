import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotebook/services/cloud/cloud_note.dart';
import 'package:mynotebook/services/cloud/cloud_storage_constants.dart';
import 'package:mynotebook/services/cloud/cloud_storage_exceptions.dart';

//create singleton
class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
//delete note
  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

//update note
  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //manage notes in our database
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    return notes.snapshots().map(
          (event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)).where(
                (note) => note.ownerUserId == ownerUserId,
              ),
        );
  }

//get all of our Notes
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
            (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._shardInstance();
  FirebaseCloudStorage._shardInstance();

  factory FirebaseCloudStorage() => _shared;
}
