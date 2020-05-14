import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/tags/tag.dart';
import './bloc.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final NoteRepository _notesRepository;

  DetailsBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository;

  @override
  DetailsState get initialState => InitialDetailsState(null);

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
    }else if(event is AddTagsClicked){
      yield* _mapAddTagsClickedToState(event);
    }
  }

  Stream<DetailsState> _mapGetNoteDetailsToState(GetNoteDetails event) async*{
    Note note = await _notesRepository.getNoteById(event.noteId);

    yield LoadingDetailsState(null);

    List<Tag> noteTags = new List<Tag>();

    if(note.tagIds != null && note.tagIds.isNotEmpty){
      for(var i = 0; i< note.tagIds.length; i++){
        final tag = await _notesRepository.getTagById(note.tagIds[i]);
        noteTags.add(tag);
      }
    }
    yield ViewDetailsState(note, noteTags);
  }

  Stream<DetailsState> _mapNewNoteModeToState(NewNoteMode event) async*{
    yield EditDetailsState(new Note(''));
  }

  Stream<DetailsState> _mapEditModeToState(EditMode event) async*{
    yield EditDetailsState(event.note);
  }

  Stream<DetailsState> _mapAddTagsClickedToState(AddTagsClicked event) async*{

    final currentState = state;

    if(currentState is EditDetailsState){
      yield currentState.update(
          addingTagsMode: true
      );
    }/*else{
      yield EditDetailsState(new Note(''), false);
    }*///TODO: add yield error
  }

  Stream<DetailsState> _mapSaveNoteToState(SaveNote event) async*{
    Note note;

    List<Tag> noteTags = new List<Tag>();

    if(event.note.id != null){
      note = await _notesRepository.updateNote(event.note);
    }else{
      note = await _notesRepository.addNewNote(event.note);
    }
    yield LoadingDetailsState(null);

    if(note.tagIds != null && note.tagIds.isNotEmpty){
      for(var i = 0; i< note.tagIds.length; i++){
        final tag = await _notesRepository.getTagById(note.tagIds[i]);
        noteTags.add(tag);
      }
    }

    yield ViewDetailsState(note, noteTags);
  }
}
