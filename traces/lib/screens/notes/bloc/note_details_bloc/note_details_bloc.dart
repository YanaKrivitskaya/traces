import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../utils/api/customException.dart';
import '../../models/create_note.model.dart';
import '../../models/note.model.dart';
import '../../repositories/api_notes_repository.dart';
import 'bloc.dart';

class NoteDetailsBloc extends Bloc<NoteDetailsEvent, NoteDetailsState> {
  final ApiNotesRepository _notesRepository;

  NoteDetailsBloc():
    _notesRepository = new ApiNotesRepository(), 
    super(InitialNoteDetailsState(null));

  @override
  Stream<NoteDetailsState> mapEventToState(
    NoteDetailsEvent event,
  ) async* {
    if(event is GetNoteDetails){
      yield* _mapGetNoteDetailsToState(event);
    }else if(event is NewNoteMode){
      yield* _mapNewNoteModeToState(event);
    }else if(event is EditModeClicked){
      yield* _mapEditModeToState(event);
    }else if(event is SaveNoteClicked){
      yield* _mapSaveNoteToState(event);
    }else if (event is DeleteNote) {
      yield* _mapDeleteNoteToState(event);
    }
  }

  Stream<NoteDetailsState> _mapGetNoteDetailsToState(GetNoteDetails event) async*{
    yield LoadingDetailsState(null);

    try{
      Note? note = await _notesRepository.getNoteById(event.noteId);
      yield ViewDetailsState(note, null);
    } on CustomException catch(e){
      yield ErrorDetailsState(state.note, e);
    }
  }

  Stream<NoteDetailsState> _mapSaveNoteToState(SaveNoteClicked event) async*{
    Note? note;
    
    try{
      if(event.note.id != null){
      note = await _notesRepository.updateNote(event.note);
    }else{
      var newNote = CreateNoteModel(
        title: event.note.title,
        content: event.note.content
      );
      note = await _notesRepository.addNewNote(newNote);
    }
    
      yield ViewDetailsState(note, null);
    } on CustomException catch(e){
      yield ErrorDetailsState(state.note, e);
    }    
  }

  Stream<NoteDetailsState> _mapDeleteNoteToState(DeleteNote event) async* {
    var currentState = state;
    yield LoadingDetailsState(null);

    try{
      await _notesRepository.deleteNote(event.note!.id);
      yield ViewDetailsState(currentState.note, true);
    }on CustomException catch(e){
       yield ErrorDetailsState(currentState.note, e);
    }   
  }

  Stream<NoteDetailsState> _mapNewNoteModeToState(NewNoteMode event) async*{
    yield EditDetailsState(new Note());
  }

  Stream<NoteDetailsState> _mapEditModeToState(EditModeClicked event) async*{
    yield EditDetailsState(event.note);
  }
}
