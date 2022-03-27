
import 'package:traces/screens/notes/models/create_note.model.dart';
import 'package:traces/screens/notes/models/note.model.dart';

abstract class NotesRepository{
  Future<List<Note>?> getNotes();

  Future<Note?> getNoteById(int? noteId);

  Future<String> deleteNote(int? noteId);

  Future<Note?> addNoteTag(int? noteId, int? tagId);

  Future<Note?> deleteNoteTag(int? noteId, int? tagId);

  Future<Note?> updateNote(Note note);

  Future<Note?> addNewNote(CreateNoteModel note);
}