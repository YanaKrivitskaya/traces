import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/notes/model/tag.dart';
import 'package:traces/screens/notes/model/tag_entity.dart';
import 'package:traces/screens/notes/model/note_entity.dart';
import 'dart:async';
import 'package:traces/screens/notes/model/note.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';

class FirebaseNotesRepository extends NoteRepository{
  final notesCollection = FirebaseFirestore.instance.collection('notes');
  final String userNotes = "userNotes";
  final String userTags = "userTags";
  
  UserRepository _userRepository;

  FirebaseNotesRepository() {
    _userRepository = new UserRepository();
    //FirebaseFirestore.instance.settings(persistenceEnabled: true);
  }

  @override
  Future<Note> addNewNote(Note note) async{
    String uid = await _userRepository.getUserId();
    final newNote = await notesCollection.doc(uid).collection(userNotes).add(note.toEntity().toDocument());
    return await getNoteById(newNote.id);
  }

  @override
  Future<void> deleteNote(Note note) async {
    String uid = await _userRepository.getUserId();
    return notesCollection.doc(uid).collection(userNotes).doc(note.id).delete();
  }

  @override
  Future<Note> getNoteById(String id) async {
    String uid = await _userRepository.getUserId();

    var resultNote = await notesCollection.doc(uid).collection(userNotes).doc(id).get();

    return Note.fromEntity(NoteEntity.fromMap(resultNote.data(), resultNote.id));
  }

  @override
  Stream<List<Note>> notes() async* {
    String uid = await _userRepository.getUserId();
    yield* notesCollection.doc(uid).collection(userNotes).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Note.fromEntity(NoteEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Note> updateNote(Note note) async {
    String uid = await _userRepository.getUserId();
    await notesCollection.doc(uid).collection(userNotes)
        .doc(note.id)
        .update(note.toEntity().toDocument());
    return await getNoteById(note.id);
  }

  //tags

  @override
  Stream<List<Tag>> tags() async*{
    String uid = await _userRepository.getUserId();
    yield* notesCollection.doc(uid).collection(userTags).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Tag.fromEntity(TagEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<Tag> addNewTag(Tag tag) async{
    String uid = await _userRepository.getUserId();
    final newTag = await notesCollection.doc(uid).collection(userTags).add(tag.toEntity().toDocument());
    return await getTagById(newTag.id);
  }

  @override
  Future<Tag> getTagById(String id) async {
    String uid = await _userRepository.getUserId();

    var resultTag = await notesCollection.doc(uid).collection(userTags).doc(id).get();

    return Tag.fromEntity(TagEntity.fromMap(resultTag.data(), resultTag.id));
  }

  @override
  Future<void> deleteTag(Tag tag) async {
    String uid = await _userRepository.getUserId();
    return notesCollection.doc(uid).collection(userNotes).doc(tag.id).delete();
  }

  @override
  Future<Tag> updateTag(Tag tag) async {
    String uid = await _userRepository.getUserId();
    await notesCollection.doc(uid).collection(userTags)
        .doc(tag.id)
        .update(tag.toEntity().toDocument());
    return await getTagById(tag.id);
  }

}