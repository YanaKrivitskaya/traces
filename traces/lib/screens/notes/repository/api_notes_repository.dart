
import 'package:traces/helpers/api.provider.dart';
import 'package:traces/screens/notes/model/note.model.dart';

import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiNotesRepository{
  ApiProvider apiProvider = ApiProvider();
  String notesUrl = 'notes/';
  final _storage = FlutterSecureStorage();

  Future<List<Note>> getNotes( )async{
    final response = await apiProvider.getSecure(notesUrl);

    /*Iterable l = json.decode(response.body);
List<Post> posts = List<Post>.from(l.map((model)=> Post.fromJson(model)));*/
    var notes = response["notes"] != null ? 
      response['notes'].map<Note>((json) => Note.fromJson(json)).toList() : null;
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