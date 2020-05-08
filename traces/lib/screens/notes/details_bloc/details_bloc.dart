import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import './bloc.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final NoteRepository _notesRepository;

  DetailsBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  DetailsState get initialState => InitialDetailsState();

  @override
  Stream<DetailsState> mapEventToState(
    DetailsEvent event,
  ) async* {
    if(event is GetNoteDetails){
      yield* _mapGetNoteDetailsToState(event);
    }else if(event is NewNoteMode){
      yield* _mapNewNoteModeToState(event);
    }else if(event is EditMode){
      yield* _mapEditModeToState(event);
    }else if(event is SaveNote){
      yield* _mapSaveNoteToState(event);
    }
  }

  Stream<DetailsState> _mapGetNoteDetailsToState(GetNoteDetails event) async*{
    Note note = await _notesRepository.getNoteById(event.noteId);
    yield ViewDetailsState(note);
  }

  Stream<DetailsState> _mapNewNoteModeToState(NewNoteMode event) async*{
    yield EditDetailsState(new Note(''));
  }

  Stream<DetailsState> _mapEditModeToState(EditMode event) async*{
    yield EditDetailsState(event.note);
  }

  Stream<DetailsState> _mapSaveNoteToState(SaveNote event) async*{
    Note note;

    if(event.note.id != null){
      note = await _notesRepository.updateNote(event.note);
    }else{
      note = await _notesRepository.addNewNote(event.note);
    }
    yield ViewDetailsState(note);
  }
}
