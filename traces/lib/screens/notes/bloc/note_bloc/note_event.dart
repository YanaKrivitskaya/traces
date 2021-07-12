import 'package:equatable/equatable.dart';

import '../../models/note.model.dart';
import '../../models/tag.model.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class GetAllNotes extends NoteEvent {}

class SearchBarToggle extends NoteEvent {}

class UpdateNotesList extends NoteEvent {
  final List<Note>? allNotes;

  final List<Note>? filteredNotes;

  final SortFields sortField;
  final SortDirections sortDirection;

  const UpdateNotesList(this.allNotes, this.sortField, this.sortDirection, this.filteredNotes);

  @override
  List<Object?> get props => [allNotes, sortField, sortDirection, filteredNotes];
}

class UpdateSortFilter extends NoteEvent{
  final SortFields sortField;
  final SortDirections sortDirection;

  UpdateSortFilter(this.sortField, this.sortDirection);

  @override
  List<Object> get props => [sortField, sortDirection];
}

class SelectedTagsUpdated extends NoteEvent{
  final List<Tag>? selectedTags;
  final bool? allTagsSelected;
  final bool? noTagsSelected;

  SelectedTagsUpdated(this.selectedTags, this.allTagsSelected, this.noTagsSelected);

  @override
  List<Object?> get props => [selectedTags, allTagsSelected, noTagsSelected];
}

/*class DeleteNote extends NoteEvent {
  final Note? note;

  const DeleteNote(this.note);

  @override
  List<Object?> get props => [note];
}*/

class SearchTextChanged extends NoteEvent{
  final String noteName;

  const SearchTextChanged({required this.noteName});

  @override
  List<Object> get props => [noteName];
}