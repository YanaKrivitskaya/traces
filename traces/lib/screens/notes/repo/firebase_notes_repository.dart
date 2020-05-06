import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/notes/note-entity.dart';
import 'dart:async';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/repo/note_repository.dart';

class FirebaseNotesRepository extends NoteRepository{
  final notesCollection = Firestore.instance.collection('notes');
  final String userNotes = "userNotes";
  
  UserRepository _userRepository;

  FirebaseNotesRepository() {
    _userRepository = new UserRepository();
  }

  @override
  Future<void> addNewNote(Note note) async{
    String uid = await _userRepository.getUserId();
    return notesCollection.document(uid).collection(userNotes).add(note.toEntity().toDocument());
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
    return Note.fromEntity(NoteEntity.fromJson(resultNote.data));
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

  Stream<List<Note>> notesSorted() async* {
    String uid = await _userRepository.getUserId();
    yield* notesCollection.document(uid).collection(userNotes).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateNote(Note note) async {
    String uid = await _userRepository.getUserId();
    return notesCollection.document(uid).collection(userNotes)
        .document(note.id)
        .updateData(note.toEntity().toDocument());
  }

}