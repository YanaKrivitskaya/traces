//import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../utils/api/customException.dart';
import '../../../../utils/misc/state_types.dart';
import '../../models/note.model.dart';
import '../../repositories/api_notes_repository.dart';
import 'bloc.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final ApiNotesRepository _notesRepository;

  NoteBloc():
    _notesRepository = new ApiNotesRepository(), 
    super(NoteState.empty()){
      on<GetAllNotes>(_onGetAllNotes);
      on<UpdateNotesList>(_onUpdateNotesList);
      on<UpdateSortFilter>(_onUpdateSortFilter);
      on<SearchBarToggle>(_onSearchBarToggle);
      on<SearchTextChanged>(_onSearchTextChanged);
      on<SelectedTagsUpdated>(_onSelectedTagsUpdated);
    }  

  void _onUpdateNotesList(UpdateNotesList event, Emitter<NoteState> emit) async{
    List<Note> filteredNotes = <Note>[];
    filteredNotes.addAll(event.allNotes!);
    return emit(NoteState.success(
      allNotes: event.allNotes, 
      filteredNotes: filteredNotes,
      sortField: event.sortField, 
      sortDirection: event.sortDirection, 
      searchEnabled: false, 
      noteDeleted: false));
  }

  void _onGetAllNotes(GetAllNotes event, Emitter<NoteState> emit) async{
    var currentState = state;
    emit(NoteState.loading());

    try{
      var notes = await _notesRepository.getNotes();     
      return emit(NoteState.success(
        allNotes: notes, 
        filteredNotes: notes,
        sortField: SortFields.DATEMODIFIED, 
        sortDirection: SortDirections.ASC, 
        searchEnabled: false, 
        noteDeleted: false));      
    }on CustomException catch(e){
      if(currentState.allNotes != null) 
        return emit(NoteState.success(
          allNotes: currentState.allNotes, 
          filteredNotes: currentState.allNotes,
          sortField: currentState.sortField, 
          sortDirection: currentState.sortDirection, 
          searchEnabled: currentState.searchEnabled, 
          noteDeleted: false, 
          exception: e));
      else return emit(NoteState.failure(error: e));
    }
  }

  void _onUpdateSortFilter(UpdateSortFilter event, Emitter<NoteState> emit) async{
    //emit(NoteState.loading());
    return emit(state.update(
      sortField: event.sortField, 
      sortDirection: event.sortDirection));
  }

  void _onSearchBarToggle(SearchBarToggle event, Emitter<NoteState> emit) async{
    emit(state.update(stateStatus: StateStatus.Loading));

    List<Note> filteredNotes = <Note>[];

    !state.searchEnabled! ? filteredNotes.addAll(state.allNotes!) :  filteredNotes.addAll(state.filteredNotes!);

    return emit(state.update(
      stateStatus: StateStatus.Success, 
      searchEnabled: !state.searchEnabled!, 
      filteredNotes: filteredNotes));
  }

  void _onSelectedTagsUpdated(SelectedTagsUpdated event, Emitter<NoteState> emit) async{
    emit(state.update(stateStatus: StateStatus.Loading));

    return emit(state.update(
      stateStatus: StateStatus.Success, 
      selectedTags: event.selectedTags, 
      allTagsSelected: event.allTagsSelected, 
      noTagsSelected: event.noTagsSelected));
  }

  void _onSearchTextChanged(SearchTextChanged event, Emitter<NoteState> emit) async{
    emit(state.update(stateStatus: StateStatus.Loading));

    List<Note> filteredNotes = <Note>[];

    event.noteName.length > 0
        ? filteredNotes = state.allNotes!.where((n) => n.title!.toLowerCase().contains(event.noteName.toLowerCase())).toList()
        : filteredNotes.addAll(state.allNotes!);

    return emit(state.update(
      filteredNotes: filteredNotes, 
      stateStatus: StateStatus.Success));
  }
}
