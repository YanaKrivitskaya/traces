import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/model/note.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class GetAllNotes extends NoteEvent {}

class UpdateNotesList extends NoteEvent {
  final List<Note> notes;
  final SortFields sortField;
  final SortDirections sortDirection;

  const UpdateNotesList(this.notes, this.sortField, this.sortDirection);

  @override
  List<Object> get props => [notes, sortField, sortDirection];
}

class UpdateSortFilter extends NoteEvent{
  final SortFields sortField;
  final SortDirections sortDirection;

  UpdateSortFilter(this.sortField, this.sortDirection);

  @override
  List<Object> get props => [sortField, sortDirection];
}

class SelectedTagsUpdated extends NoteEvent{}

class DeleteNote extends NoteEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Object> get props => [note];
}