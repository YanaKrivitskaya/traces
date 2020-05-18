import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NotesEmpty extends NoteState {}

class NotesLoadInProgress extends NoteState {}

class NotesLoadSuccess extends NoteState {
  final List<Note> notes;

  final SortFields sortField;
  final SortDirections sortDirection;

  const NotesLoadSuccess(
      SortFields sortField,
      SortDirections sortDirection,
      this.notes
      ) : sortField = sortField ?? SortFields.DATEMODIFIED,
        sortDirection = sortDirection ?? SortDirections.ASC;

  @override
  List<Object> get props => [notes];
}

class NotesLoadFailure extends NoteState {
  final String error;

  NotesLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}