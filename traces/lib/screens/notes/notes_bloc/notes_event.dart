import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/notes_bloc/bloc.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
abstract class NotesEvent extends Equatable{
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class GetNotes extends NotesEvent {}

class AddNote extends NotesEvent{
  final Note note;

  const AddNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateNotesList extends NotesEvent {
  final List<Note> notes;
  final SortFields sortField;
  final SortDirections sortDirection;

  const UpdateNotesList(this.notes, this.sortField, this.sortDirection);

  @override
  List<Object> get props => [notes, sortField, sortDirection];
}

class UpdateSortOrder extends NotesEvent {
  final SortFields sortField;
  final SortDirections sortDirection;

  const UpdateSortOrder(this.sortField, this.sortDirection);

  @override
  List<Object> get props => [sortField, sortDirection];
}
