
import 'dart:io';

import 'package:traces/screens/notes/models/create_note.model.dart';
import 'package:traces/screens/notes/models/note.model.dart';
import 'package:image_cropper/image_cropper.dart';

abstract class NotesRepository{
  Future<List<Note>?> getNotes();

  Future<Note?> getNoteById(int? noteId);

  Future<String> deleteNote(int? noteId);

  Future<Note?> addNoteTag(int? noteId, int? tagId);

  Future<Note?> deleteNoteTag(int? noteId, int? tagId);

  Future<Note?> updateNote(Note note);

  Future<Note?> addNewNote(CreateNoteModel note);

  Future<Note> updateNoteImage(CroppedFile? image, int noteId);

  Future<Note?> addNoteTrip(int? noteId, int? tripId);
}