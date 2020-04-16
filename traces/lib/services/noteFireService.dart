import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

// Reference to a Collection
CollectionReference notesCollectionRef = Firestore.instance.collection('notes');
final String notesCollection = "userNotes";
final BaseAuth auth = new Auth();

class NoteFireService{
  Future<String> createNote(String title, String text) async{
    String uid = await auth.getUserId();

    DocumentReference ref = await notesCollectionRef.document(uid).collection(notesCollection).add({
      "title": title,
      "text": text,
      "dateCreated": DateTime.now(),
      "dateModified": DateTime.now()
    });

    await notesCollectionRef.document(uid).collection(notesCollection).document(ref.documentID).updateData({"id": ref.documentID});
    return ref.documentID;
  }

  Stream<QuerySnapshot> getNotes() async*{
    String uid = await auth.getUserId();

    Stream<QuerySnapshot> snapshots = notesCollectionRef.document(uid).collection(notesCollection).snapshots();

    /*notesCollectionRef.document(uid).collection(notesCollection).getDocuments().then(
        (QuerySnapshot snapshot){
          snapshot.documents.forEach((f) => print('${f.data}'));
        }
    );*/
    yield* snapshots;
  }
}