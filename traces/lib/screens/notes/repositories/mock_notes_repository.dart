
import 'dart:io';
import 'dart:math';

import 'package:traces/screens/notes/models/note.model.dart';
import 'package:traces/screens/notes/models/create_note.model.dart';
import 'package:traces/screens/notes/models/tag.model.dart';
import 'package:traces/screens/notes/repositories/notes_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';

class MockNotesRepository extends NotesRepository{
  @override
  Future<Note?> addNewNote(CreateNoteModel note) async {
    print("MockNotesRepository.addNewNote");
    var rng = Random();
    return _getNote(rng.nextInt(100) + 10);
  }

  @override
  Future<Note?> addNoteTag(int? noteId, int? tagId) {
    // TODO: implement addNoteTag
    throw UnimplementedError();
  }

  @override
  Future<String> deleteNote(int? noteId) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Note?> deleteNoteTag(int? noteId, int? tagId) {
    // TODO: implement deleteNoteTag
    throw UnimplementedError();
  }

  @override
  Future<Note?> getNoteById(int? noteId) async {
    print("MockNotesRepository.getNoteById");
    return _getNote(1);
  }

  @override
  Future<List<Note>?> getNotes() async {
    print("MockNotesRepository.getNotes");
    var notes = new List<Note>.empty(growable: true);

    var rng = Random();

    for (var i=0; i<rng.nextInt(10); i++){
      notes.add(_getNote(i));
    }    

    return notes;
  }

  @override
  Future<Note?> updateNote(Note note) async{
    print("MockNotesRepository.updateNote");
    return _getNote(1);
  }

  Note _getNote(int id){
    var rng = Random();

    int hasTrip = rng.nextInt(3);

    List<String> tripsList = ["Summer trip", "Portugal", "Winter vacation"];

    var tripIndex = rng.nextInt(2);
    return new Note(
      id: id,
      title: "Test Note",
      content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      createdDate: DateTime.now().add(new Duration(days: -1)),
      updatedDate: DateTime.now(),
      tags: [
        new Tag(
          id: 1,
          name: "testTag"
        )
      ],
      trip: hasTrip >1 ? new Trip(
        id: 1,
        name: tripsList[tripIndex]
      ) : null
    );
  }

  @override
  Future<Note> updateNoteImage(File? image, int noteId) {
    // TODO: implement updateNoteImage
    throw UnimplementedError();
  }
  
  @override
  Future<Note?> addNoteTrip(int? noteId, int? tripId){
    // TODO: implement updateNoteImage
    throw UnimplementedError();
  }


}