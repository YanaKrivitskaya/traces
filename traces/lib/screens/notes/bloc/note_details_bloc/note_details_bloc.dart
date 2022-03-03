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
    super(InitialNoteDetailsState(null)){
      on<GetNoteDetails>(_onGetNoteDetails);
      on<EditModeClicked>(_onEditModeClicked);
      on<SaveNoteClicked>(_onSaveNoteClicked);
      on<DeleteNote>(_onDeleteNote);
      on<NewNoteMode>(_onNewNoteMode);
    }  

  void _onGetNoteDetails(GetNoteDetails event, Emitter<NoteDetailsState> emit) async{
    emit(LoadingDetailsState(null));

    try{
      Note? note = await _notesRepository.getNoteById(event.noteId);
      return emit(ViewDetailsState(note, null));
    } on CustomException catch(e){
      return emit (ErrorDetailsState(state.note, e));
    }
  }

  void _onSaveNoteClicked(SaveNoteClicked event, Emitter<NoteDetailsState> emit) async{
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
    
      return emit(ViewDetailsState(note, null));
    } on CustomException catch(e){
      return emit(ErrorDetailsState(state.note, e));
    }
  }

  void _onDeleteNote(DeleteNote event, Emitter<NoteDetailsState> emit) async{
    var currentState = state;
    emit(LoadingDetailsState(null));

    try{
      await _notesRepository.deleteNote(event.note!.id);
      return emit(ViewDetailsState(currentState.note, true));
    }on CustomException catch(e){
       return emit(ErrorDetailsState(currentState.note, e));
    }   
  }

  void _onNewNoteMode(NewNoteMode event, Emitter<NoteDetailsState> emit) async{
    return emit(EditDetailsState(new Note()));
  }

  void _onEditModeClicked(EditModeClicked event, Emitter<NoteDetailsState> emit) async{
    return emit(EditDetailsState(event.note));
  }  
}
