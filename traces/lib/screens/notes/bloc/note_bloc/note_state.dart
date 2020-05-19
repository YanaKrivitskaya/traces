import 'package:meta/meta.dart';
import 'package:traces/screens/notes/model/note.dart';

class NoteState{
  final List<Note> allNotes;
  final List<Note> filteredNotes;
  final SortFields sortField;
  final SortDirections sortDirection;
  final bool searchEnabled;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;


  const NoteState({
    @required this.allNotes,
    @required this.filteredNotes,
    @required this.sortField,
    @required this.sortDirection,
    @required this.searchEnabled,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory NoteState.empty(){
    return NoteState(
        allNotes: null,
        filteredNotes: null,
        sortField: SortFields.DATEMODIFIED,
        sortDirection: SortDirections.ASC,
        searchEnabled: false,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
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
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory NoteState.success({List<Note> allNotes, List<Note> filteredNotes, SortFields sortField,
    SortDirections sortDirection, bool searchEnabled}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory NoteState.failure({List<Note> allNotes, List<Note> filteredNotes, SortFields sortField,
    SortDirections sortDirection, String error, bool searchEnabled}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: error
    );
  }

  NoteState copyWith({
    final List<Note> allNotes,
    final List<Note> filteredNotes,
    final SortFields sortField,
    final SortDirections sortDirection,
    bool searchEnabled,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return NoteState(
        allNotes: allNotes ?? this.allNotes,
        filteredNotes: filteredNotes ?? this.filteredNotes,
        sortField: sortField ?? this.sortField,
        sortDirection: sortDirection ?? this.sortDirection,
        searchEnabled: searchEnabled ?? this.searchEnabled,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  NoteState update({
    List<Note> allNotes,
    List<Note> filteredNotes,
    SortFields sortField,
    SortDirections sortDirection,
    bool searchEnabled,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }
}