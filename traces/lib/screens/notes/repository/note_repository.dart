import 'dart:async';

import 'package:traces/screens/notes/tags/tag.dart';
import 'package:traces/screens/notes/note.dart';

abstract class NoteRepository {
  Future<Note> addNewNote(Note note);

  Future<void> deleteNote(Note note);

  Future<Tag> addNewTag(Tag tag);

  Future<void> deleteTag(Tag tag);

  Stream<List<Note>> notes();

  Stream<List<Tag>> tags();

  Future<Note> updateNote(Note note);

  Future<Tag> updateTag(Tag tag);

  Future<Note> getNoteById(String id);

  Future<Tag> getTagById(String id);
}