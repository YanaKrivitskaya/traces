import 'package:meta/meta.dart';

import '../../../../shared/state_types.dart';
import '../../model/note.model.dart';

class NoteState{
  final List<Note> allNotes;
  final List<Note> filteredNotes;
  final SortFields sortField;
  final SortDirections sortDirection;
  final bool searchEnabled;
  final bool noteDeleted;
  final StateStatus status;
  final String errorMessage;


  const NoteState({
    @required this.allNotes,
    @required this.filteredNotes,
    @required this.sortField,
    @required this.sortDirection,
    @required this.searchEnabled,
    @required this.noteDeleted,
    @required this.status,
    this.errorMessage});

  factory NoteState.empty(){
    return NoteState(
        allNotes: null,
        filteredNotes: null,
        sortField: SortFields.DATEMODIFIED,
        sortDirection: SortDirections.ASC,
        searchEnabled: false,
        noteDeleted: false,
        status: StateStatus.Empty,
        errorMessage: ""
    );
  }

  factory NoteState.loading(){
    return NoteState(
        allNotes: null,
        filteredNotes: null,
        sortField: SortFields.DATEMODIFIED,
        sortDirection: SortDirections.ASC,
        searchEnabled: false,
        noteDeleted: false,
        status: StateStatus.Loading,
        errorMessage: ""
    );
  }

  factory NoteState.success({List<Note> allNotes, List<Note> filteredNotes, SortFields sortField,
    SortDirections sortDirection, bool searchEnabled, bool noteDeleted}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        noteDeleted: noteDeleted,
        status: StateStatus.Success,
        errorMessage: ""
    );
  }

  factory NoteState.failure({List<Note> allNotes, List<Note> filteredNotes, SortFields sortField,
    SortDirections sortDirection, String error, bool searchEnabled, bool noteDeleted}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        noteDeleted: noteDeleted,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  NoteState copyWith({
    final List<Note> allNotes,
    final List<Note> filteredNotes,
    final SortFields sortField,
    final SortDirections sortDirection,
    bool searchEnabled,
    bool noteDeleted,
    StateStatus status,
    String errorMessage
  }){
    return NoteState(
        allNotes: allNotes ?? this.allNotes,
        filteredNotes: filteredNotes ?? this.filteredNotes,
        sortField: sortField ?? this.sortField,
        sortDirection: sortDirection ?? this.sortDirection,
        searchEnabled: searchEnabled ?? this.searchEnabled,
        noteDeleted: noteDeleted ?? this.noteDeleted,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  NoteState update({
    List<Note> allNotes,
    List<Note> filteredNotes,
    SortFields sortField,
    SortDirections sortDirection,
    bool searchEnabled,
    bool noteDeleted,
    StateStatus stateStatus,
    String errorMessage
  }){
    return copyWith(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        noteDeleted: noteDeleted,
        status: stateStatus,
        errorMessage: errorMessage
    );
  }
}