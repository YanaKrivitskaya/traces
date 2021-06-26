
import '../../../../utils/misc/state_types.dart';
import '../../models/note.model.dart';
import '../../models/tag.model.dart';

class NoteState{
  final List<Note>? allNotes;
  final List<Note>? filteredNotes;
  final List<Tag>? selectedTags;
  final SortFields? sortField;
  final SortDirections? sortDirection;
  final bool? searchEnabled;
  final bool? allTagsSelected;
  final bool? noTagsSelected;
  final bool? noteDeleted;
  final StateStatus status;
  final String? errorMessage;


  const NoteState({
    required this.allNotes,
    required this.filteredNotes,
    required this.sortField,
    required this.sortDirection,
    required this.searchEnabled,
    required this.noteDeleted,
    required this.status,
    this.selectedTags,
    this.allTagsSelected,
    this.noTagsSelected,
    this.errorMessage});

  factory NoteState.empty(){
    return NoteState(
        allNotes: null,
        filteredNotes: null,
        selectedTags: null,
        sortField: SortFields.DATEMODIFIED,
        sortDirection: SortDirections.ASC,
        searchEnabled: false,
        allTagsSelected: false,
        noTagsSelected: false,
        noteDeleted: false,
        status: StateStatus.Empty,
        errorMessage: ""
    );
  }

  factory NoteState.loading(){
    return NoteState(
        allNotes: null,
        filteredNotes: null,
        selectedTags: null,
        sortField: SortFields.DATEMODIFIED,
        sortDirection: SortDirections.ASC,
        searchEnabled: false,
        allTagsSelected: false,
        noTagsSelected: false,
        noteDeleted: false,
        status: StateStatus.Loading,
        errorMessage: ""
    );
  }

  factory NoteState.success({List<Note>? allNotes, List<Note>? filteredNotes, List<Tag>? selectedTags, SortFields? sortField,
    SortDirections? sortDirection, bool? searchEnabled, bool? allTagsSelected, bool? noTagsSelected, bool? noteDeleted}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        selectedTags: selectedTags,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        allTagsSelected: allTagsSelected,
        noTagsSelected: noTagsSelected,
        noteDeleted: noteDeleted,
        status: StateStatus.Success,
        errorMessage: ""
    );
  }

  factory NoteState.failure({List<Note>? allNotes, List<Note>? filteredNotes, List<Tag>? selectedTags, SortFields? sortField,
    SortDirections? sortDirection, String? error, bool? searchEnabled, bool? allTagsSelected, bool? noTagsSelected, bool? noteDeleted}){
    return NoteState(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        selectedTags: selectedTags,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        allTagsSelected: allTagsSelected,
        noTagsSelected: noTagsSelected,
        noteDeleted: noteDeleted,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  NoteState copyWith({
    final List<Note>? allNotes,
    final List<Note>? filteredNotes,
    final List<Tag>? selectedTags,
    final SortFields? sortField,
    final SortDirections? sortDirection,
    bool? searchEnabled,
    bool? noteDeleted,
    bool? allTagsSelected,
    bool? noTagsSelected,
    StateStatus? status,
    String? errorMessage
  }){
    return NoteState(
        allNotes: allNotes ?? this.allNotes,
        filteredNotes: filteredNotes ?? this.filteredNotes,
        selectedTags: selectedTags ?? this.selectedTags,
        sortField: sortField ?? this.sortField,
        sortDirection: sortDirection ?? this.sortDirection,
        searchEnabled: searchEnabled ?? this.searchEnabled,
        allTagsSelected: allTagsSelected ?? this.allTagsSelected,
        noTagsSelected: noTagsSelected ?? this.noTagsSelected,
        noteDeleted: noteDeleted ?? this.noteDeleted,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  NoteState update({
    List<Note>? allNotes,
    List<Note>? filteredNotes,
     final List<Tag>? selectedTags,
    SortFields? sortField,
    SortDirections? sortDirection,
    bool? searchEnabled,
    bool? allTagsSelected,
    bool? noTagsSelected,
    bool? noteDeleted,
    StateStatus? stateStatus,
    String? errorMessage
  }){
    return copyWith(
        allNotes: allNotes,
        filteredNotes: filteredNotes,
        selectedTags: selectedTags,
        sortField: sortField,
        sortDirection: sortDirection,
        searchEnabled: searchEnabled,
        allTagsSelected: allTagsSelected,
        noTagsSelected: noTagsSelected,
        noteDeleted: noteDeleted,
        status: stateStatus,
        errorMessage: errorMessage
    );
  }
}