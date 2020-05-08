import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/notes/note_entity.dart';
import 'dart:async';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';

class FirebaseNotesRepository extends NoteRepository{
  final notesCollection = Firestore.instance.collection('notes');
  final String userNotes = "userNotes";
  
  UserRepository _userRepository;

  FirebaseNotesRepository() {
    _userRepository = new UserRepository();
  }

  @override
  Future<Note> addNewNote(Note note) async{
    String uid = await _userRepository.getUserId();
    final newNote = await notesCollection.document(uid).collection(userNotes).add(note.toEntity().toDocument());
    return await getNoteById(newNote.documentID);
  }

  @override
  Future<void> deleteNote(Note note) async {
    String uid = await _userRepository.getUserId();
    return notesCollection.document(uid).collection(userNotes).document(note.id).delete();
  }

  @override
  Future<Note> getNoteById(String id) async {
    String uid = await _userRepository.getUserId();

    var resultNote = await notesCollection.document(uid).collection(userNotes).document(id).get();

    return Note.fromEntity(NoteEntity.fromMap(resultNote.data, resultNote.documentID));
  }

  @override
  Stream<List<Note>> notes() async* {
    String uid = await _userRepository.getUserId();
    yield* notesCollection.document(uid).collection(userNotes).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Note> updateNote(Note note) async {
    String uid = await _userRepository.getUserId();
    await notesCollection.document(uid).collection(userNotes)
        .document(note.id)
        .updateData(note.toEntity().toDocument());
    return await getNoteById(note.id);
  }

}