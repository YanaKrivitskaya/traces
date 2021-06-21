import '../../../utils/api/api.provider.dart';
import '../models/create_note.model.dart';
import '../models/note.model.dart';

class ApiNotesRepository{
  ApiProvider apiProvider = ApiProvider();
  String notesUrl = 'notes/';

  Future<List<Note>?> getNotes( )async{
    final response = await apiProvider.getSecure(notesUrl);
      
    var notes = response["notes"] != null ? 
      response['notes'].map<Note>((map) => Note.fromMap(map)).toList() : null;
    return notes;
  }

  Future<Note?> getNoteById(int? noteId) async {
    final response = await apiProvider.getSecure(notesUrl + '/$noteId');
    
    var note = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return note;
  }

  Future<void> deleteNote(int? noteId) async {
    await apiProvider.deleteSecure(notesUrl + '/$noteId');    
  }

  Future<Note?> addNoteTag(int? noteId, int? tagId) async {
    final response = await apiProvider.postSecure(notesUrl + '$noteId/tags/$tagId', null);
    
    var note = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return note;
  }

  Future<Note?> deleteNoteTag(int? noteId, int? tagId) async {
    final response = await apiProvider.deleteSecure(notesUrl + '$noteId/tags/$tagId');
    
    var note = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return note;
  }

  Future<Note?> updateNote(Note note) async{
    final response = await apiProvider.putSecure(notesUrl + '${note.id}', note.toJson());
    
    var newNote = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return newNote;
  }

  Future<Note?> addNewNote(CreateNoteModel note) async{
    final response = await apiProvider.postSecure(notesUrl, note.toJson());
    
    var newNote = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return newNote;
  }
}