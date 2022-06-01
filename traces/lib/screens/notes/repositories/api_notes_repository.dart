import 'dart:io';

import 'package:traces/screens/notes/repositories/notes_repository.dart';

import '../../../utils/services/api_service.dart';
import '../models/create_note.model.dart';
import '../models/note.model.dart';
import 'package:image_cropper/image_cropper.dart';

class ApiNotesRepository extends NotesRepository{
  ApiService apiProvider = ApiService();
  String notesUrl = 'notes/';

  Future<List<Note>?> getNotes( )async{
    print("getNotes");
    final response = await apiProvider.getSecure(notesUrl);
      
    var notes = response["notes"] != null ? 
      response['notes'].map<Note>((map) => Note.fromMap(map)).toList() : null;
    return notes;
  }

  Future<List<Note>?> getTripNotes(int tripId) async{    
    print("getTripNotes");
    
    final queryParameters = {
      'tripId': tripId.toString()
    };
    final response = await apiProvider.getSecure(notesUrl + '/trip', queryParams: queryParameters);
      
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

  Future<String> deleteNote(int? noteId) async {    
    var response = await apiProvider.deleteSecure(notesUrl + '/$noteId');
    return response["message"] ?? null;
  }

  Future<Note?> addNoteTag(int? noteId, int? tagId) async {     
    final response = await apiProvider.postSecure(notesUrl + '$noteId/tags/$tagId', null);
    
    var note = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return note;
  }

  Future<Note?> addNoteTrip(int? noteId, int? tripId) async {     
    final response = await apiProvider.postSecure(notesUrl + '$noteId/trips/$tripId', null);
    
    var note = response["note"] != null ?
      Note.fromMap(response["note"]) : null;
    return note;
  }

    Future<Note?> deleteNoteTrip(int? noteId, int? tripId) async {
    final response = await apiProvider.deleteSecure(notesUrl + '$noteId/trips/$tripId');
    
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

  Future<Note> updateNoteImage(CroppedFile? image, int noteId)async{
    var imageBytes = await image?.readAsBytes();
    final response = await apiProvider.postSecureMultipart("$notesUrl$noteId/image", null, imageBytes, image?.path ?? '');
    var note = Note.fromMap(response['response']);
    return note;   
  }
}