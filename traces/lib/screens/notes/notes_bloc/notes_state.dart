import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
abstract class NotesState extends Equatable {

  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesEmpty extends NotesState {}

class NotesLoadInProgress extends NotesState {}

class NotesLoadSuccess extends NotesState {
  final List<Note> notes;

  final SortFields sortField;
  final SortDirections sortDirection;

  final bool allTagsSelected;

  const NotesLoadSuccess(
      SortFields sortField,
      SortDirections sortDirection,
      this.notes, this.allTagsSelected,
      ) : sortField = sortField ?? SortFields.DATEMODIFIED,
        sortDirection = sortDirection ?? SortDirections.ASC;

  @override
  List<Object> get props => [notes, allTagsSelected];

  /*@override
  String toString(){
    return '''NotesState{      
      notes: $notes
    }''';
  }*/
}

class NotesLoadFailure extends NotesState {
  final String error;

  NotesLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}