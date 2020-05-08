import 'dart:async';

import 'package:traces/screens/notes/note.dart';

abstract class NoteRepository {
  Future<Note> addNewNote(Note note);

  Future<void> deleteNote(Note note);

  Stream<List<Note>> notes();

  Future<Note> updateNote(Note note);

  Future<Note> getNoteById(String id);
}