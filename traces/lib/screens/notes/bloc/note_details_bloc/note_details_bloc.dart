import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:traces/screens/notes/repository/note_repository.dart';
import 'package:traces/screens/notes/model/tag.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

class NoteDetailsBloc extends Bloc<NoteDetailsEvent, NoteDetailsState> {
  final NoteRepository _notesRepository;

  NoteDetailsBloc({@required NoteRepository notesRepository})
      : assert(notesRepository != null),
        _notesRepository = notesRepository, super(InitialNoteDetailsState(null));

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
    }
  }

  Stream<NoteDetailsState> _mapGetNoteDetailsToState(GetNoteDetails event) async*{
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

  Stream<NoteDetailsState> _mapSaveNoteToState(SaveNoteClicked event) async*{
    Note note;

    List<Tag> noteTags = new List<Tag>();

    if(event.note.id != null){
      note = await _notesRepository.updateNote(event.note).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return event.note;
      });
    }else{
      note = await _notesRepository.addNewNote(event.note).timeout(Duration(seconds: 3), onTimeout: (){
        print("have timeout");
        return event.note;
      });
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

  Stream<NoteDetailsState> _mapNewNoteModeToState(NewNoteMode event) async*{
    yield EditDetailsState(new Note(''));
  }

  Stream<NoteDetailsState> _mapEditModeToState(EditModeClicked event) async*{
    yield EditDetailsState(event.note);
  }
}
