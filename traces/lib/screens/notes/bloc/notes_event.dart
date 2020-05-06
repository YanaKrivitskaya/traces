import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/bloc/bloc.dart';
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
  final OrderOptions orderOption;
  final SortOptions sortOption;

  const UpdateNotesList(this.notes, this.orderOption, this.sortOption);

  @override
  List<Object> get props => [notes, sortOption, orderOption];
}

class UpdateSortOrder extends NotesEvent {
  final OrderOptions orderOption;
  final SortOptions sortOption;

  const UpdateSortOrder(this.orderOption, this.sortOption);

  @override
  List<Object> get props => [orderOption, sortOption];
}
