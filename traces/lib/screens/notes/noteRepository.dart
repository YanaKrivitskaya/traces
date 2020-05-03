import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/Models/noteModel.dart';
import 'package:traces/auth/userRepository.dart';

// Reference to a Collection
CollectionReference notesCollectionRef = Firestore.instance.collection('notes');
final String notesCollection = "userNotes";
final String categoryCollection = "userCategories";

UserRepository _userRepository;

class NoteRepository {

  NoteRepository() {
    _userRepository = new UserRepository();
  }


  Future<NoteModel> createNote(String title, String text) async{
    String uid = await _userRepository.getUserId();

    DocumentReference ref = await notesCollectionRef.document(uid).collection(notesCollection).add({
      "title": (title != '' && title != null) ? title : 'No title',
      "text": text,
      "dateCreated": DateTime.now(),
      "dateModified": DateTime.now(),
      "tagIds": new List<String>()
    });

    await notesCollectionRef.document(uid).collection(notesCollection).document(ref.documentID).updateData({"id": ref.documentID});
    return await getNoteById(ref.documentID);
  }

  Stream<QuerySnapshot> getNotes() async*{
    String uid = await _userRepository.getUserId();

    Stream<QuerySnapshot> snapshots = notesCollectionRef.document(uid).collection(notesCollection).snapshots();

    yield* snapshots;
  }

  Stream<QuerySnapshot> getCategories() async*{
    String uid = await _userRepository.getUserId();

    Stream<QuerySnapshot> snapshots = notesCollectionRef.document(uid).collection(categoryCollection).snapshots();

    yield* snapshots;
  }

  Future<NoteModel> getNoteById(String id) async{
    String uid = await _userRepository.getUserId();

    var resultNote = await notesCollectionRef.document(uid).collection(notesCollection).document(id).get();
    return NoteModel.fromMap(resultNote.data);
  }

  Future<void> deleteNote(String id) async{
    String uid = await _userRepository.getUserId();
    await notesCollectionRef.document(uid).collection(notesCollection).document(id).delete();
  }

  Future<NoteModel> updateNote(NoteModel note) async{
    String uid = await _userRepository.getUserId();

    DocumentSnapshot  ds = await notesCollectionRef.document(uid).collection(notesCollection).document(note.id).get();
    print(ds);
    await ds.reference.updateData(note.toMap());
    return await getNoteById(note.id);
  }

}