import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/Models/noteModel.dart';

import 'auth.dart';

// Reference to a Collection
CollectionReference notesCollectionRef = Firestore.instance.collection('notes');
final String notesCollection = "userNotes";
final String tagsCollection = "userTags";
final BaseAuth auth = new Auth();

class NoteFireService{
  Future<NoteModel> createNote(String title, String text) async{
    String uid = await auth.getUserId();

    DocumentReference ref = await notesCollectionRef.document(uid).collection(notesCollection).add({
      "title": (title != '' && title != null) ? title : 'No title',
      "text": text,
      "dateCreated": DateTime.now(),
      "dateModified": DateTime.now()
    });

    await notesCollectionRef.document(uid).collection(notesCollection).document(ref.documentID).updateData({"id": ref.documentID});
    return await getNoteById(ref.documentID);
  }

  Stream<QuerySnapshot> getNotes() async*{
    String uid = await auth.getUserId();

    Stream<QuerySnapshot> snapshots = notesCollectionRef.document(uid).collection(notesCollection).snapshots();

    yield* snapshots;
  }

  Stream<QuerySnapshot> getTags() async*{
    String uid = await auth.getUserId();

    Stream<QuerySnapshot> snapshots = notesCollectionRef.document(uid).collection(tagsCollection).snapshots();

    yield* snapshots;
  }

  Future<NoteModel> getNoteById(String id) async{
    String uid = await auth.getUserId();

    var resultNote = await notesCollectionRef.document(uid).collection(notesCollection).document(id).get();
    return NoteModel.fromMap(resultNote.data);
  }

  Future<void> deleteNote(String id) async{
    String uid = await auth.getUserId();
    await notesCollectionRef.document(uid).collection(notesCollection).document(id).delete();
  }

  Future<NoteModel> updateNote(NoteModel note) async{
    String uid = await auth.getUserId();

    DocumentSnapshot  ds = await notesCollectionRef.document(uid).collection(notesCollection).document(note.id).get();
    print(ds);
    await ds.reference.updateData(note.toMap());
    return await getNoteById(note.id);
  }

}