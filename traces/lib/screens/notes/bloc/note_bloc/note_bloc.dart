import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../helpers/customException.dart';
import '../../../../shared/state_types.dart';
import '../../model/note.model.dart';
import '../../repository/api_notes_repository.dart';
import 'bloc.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final ApiNotesRepository _notesRepository;

  NoteBloc():
    _notesRepository = new ApiNotesRepository(), super(NoteState.empty());

  @override
  Stream<NoteState> mapEventToState(
    NoteEvent event,
  ) async* {
    if (event is GetAllNotes) {
      yield* _mapGetAllNotesToState();
    } else if (event is DeleteNote) {
      yield* _mapDeleteNoteToState(event);
    }else if (event is UpdateNotesList) {
      yield* _mapUpdateNotesListToState(event);
    }else if(event is UpdateSortFilter){
      yield* _mapNotesUpdateSortFilterToState(event);
    } else if(event is SelectedTagsUpdated){
      yield* _mapSelectedTagsUpdatedToState(event);
    } else if(event is SearchTextChanged){
      yield* _mapSearchTextChangedToState(event);
    } else if(event is SearchBarToggle){
      yield* _mapSearchBarToggleToState(event);
    }
  }

  Stream<NoteState> _mapUpdateNotesListToState(UpdateNotesList event) async* {
    List<Note> filteredNotes = <Note>[];
    filteredNotes.addAll(event.allNotes);
    yield NoteState.success(allNotes: event.allNotes, filteredNotes: filteredNotes,
        sortField: event.sortField, sortDirection: event.sortDirection, searchEnabled: false, noteDeleted: false);
  }

  Stream<NoteState> _mapGetAllNotesToState() async* {   
    yield NoteState.loading();

    try{
      var notes = await _notesRepository.getNotes();
      add(UpdateNotesList(notes, SortFields.DATEMODIFIED, SortDirections.ASC, notes));
    }on CustomException catch(e){
      yield NoteState.failure(error: e.toString());
    }    
  }

  Stream<NoteState> _mapNotesUpdateSortFilterToState(UpdateSortFilter event) async*{
    yield NoteState.loading();
    yield state.update(sortField: event.sortField, sortDirection: event.sortDirection);
  }

  Stream<NoteState> _mapSearchBarToggleToState(SearchBarToggle event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Note> filteredNotes = <Note>[];

    !state.searchEnabled ? filteredNotes.addAll(state.allNotes) :  filteredNotes.addAll(state.filteredNotes);

    yield state.update(stateStatus: StateStatus.Success, searchEnabled: !state.searchEnabled, filteredNotes: filteredNotes);
  }

  Stream<NoteState> _mapDeleteNoteToState(DeleteNote event) async* {

    try{
      await _notesRepository.deleteNote(event.note.id);
      state.allNotes?.removeWhere((n) => n.id == event.note.id);
      state.filteredNotes?.removeWhere((n) => n.id == event.note.id);
      yield state.update(allNotes: state.allNotes, filteredNotes: state.filteredNotes, noteDeleted: true);
    }on CustomException catch(e){
      yield NoteState.failure(error: e.toString());
    }   
  }

  Stream<NoteState> _mapSelectedTagsUpdatedToState(SelectedTagsUpdated event) async* {
    yield state.update(stateStatus: StateStatus.Loading);
    yield state.update(stateStatus: StateStatus.Success);
  }

  Stream<NoteState> _mapSearchTextChangedToState(SearchTextChanged event) async*{
    yield state.update(stateStatus: StateStatus.Loading);

    List<Note> filteredNotes = <Note>[];

    event.noteName.length > 0
        ? filteredNotes = state.allNotes.where((n) => n.title.toLowerCase().contains(event.noteName.toLowerCase())).toList()
        : filteredNotes.addAll(state.allNotes);

    yield state.update(filteredNotes: filteredNotes, stateStatus: StateStatus.Success);
  }
}
