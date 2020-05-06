import 'dart:async';

import 'package:traces/screens/notes/note.dart';

abstract class NoteRepository {
  Future<void> addNewNote(Note note);

  Future<void> deleteNote(Note note);

  Stream<List<Note>> notes();

  Future<void> updateNote(Note note);

  Future<Note> getNoteById(String id);
}