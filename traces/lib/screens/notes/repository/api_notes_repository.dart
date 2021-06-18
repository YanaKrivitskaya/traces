
import 'package:traces/helpers/api.provider.dart';
import 'package:traces/screens/notes/model/note.model.dart';

class ApiNotesRepository{
  ApiProvider apiProvider = ApiProvider();
  String notesUrl = 'notes/';

  Future<List<Note>> getNotes( )async{
    final response = await apiProvider.getSecure(notesUrl);
      
    var notes = response["notes"] != null ? 
      response['notes'].map<Note>((map) => Note.fromMap(map)).toList() : null;
    return notes;
  }

 /* @override
  Future<Note> addNewNote(Note note) {
    // TODO: implement addNewNote
    throw UnimplementedError();
  }

  @override
  Future<Tag> addNewTag(Tag tag) {
    // TODO: implement addNewTag
    throw UnimplementedError();
  }

  @override
  Future<void> deleteNote(Note note) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTag(Tag tag) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<Note> getNoteById(String id) {
    // TODO: implement getNoteById
    throw UnimplementedError();
  }

  @override
  Future<Tag> getTagById(String id) {
    // TODO: implement getTagById
    throw UnimplementedError();
  }

  @override
  Stream<List<Note>> notes() {
    // TODO: implement notes
    throw UnimplementedError();
  }

  @override
  Stream<List<Tag>> tags() {
    // TODO: implement tags
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNote(Note note) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }

  @override
  Future<Tag> updateTag(Tag tag) {
    // TODO: implement updateTag
    throw UnimplementedError();
  }*/

}