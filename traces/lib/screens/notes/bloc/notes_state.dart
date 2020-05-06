import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';

enum SortOptions{
  TITLE,
  DATECREATED,
  DATEMODIFIED
}
enum OrderOptions{
  ASC,
  DESC
}

@immutable
abstract class NotesState extends Equatable {

  final SortOptions sortOption;
  final OrderOptions orderOption;

  const NotesState(SortOptions sortOption,
    OrderOptions orderOption
  ): sortOption = sortOption ?? SortOptions.DATEMODIFIED,
     orderOption = orderOption ?? OrderOptions.ASC;


  @override
  String toString(){
    return '''NotesState{
      orderOption: $orderOption,
      sortOption: $sortOption      
    }''';
  }

  @override
  List<Object> get props => [];
}

class NotesEmpty extends NotesState {
  NotesEmpty(SortOptions sortOption, OrderOptions orderOption)
      : super(sortOption, orderOption);

}

class NotesLoadInProgress extends NotesState {
  NotesLoadInProgress(SortOptions sortOption, OrderOptions orderOption)
      : super(sortOption, orderOption);

}

class NotesLoadSuccess extends NotesState {
  final List<Note> notes;

  const NotesLoadSuccess(
      SortOptions sortOption,
      OrderOptions orderOption,
      this.notes
      ) : super(sortOption, orderOption);

  @override
  List<Object> get props => [notes];

  @override
  String toString(){
    return '''NotesState{
      orderOption: $orderOption,
      sortOption: $sortOption,
      notes: $notes
    }''';
  }
}

class NotesLoadFailure extends NotesState {
  final String error;

  NotesLoadFailure(SortOptions sortOption, OrderOptions orderOption, this.error)
      : super(sortOption, orderOption);

  @override
  List<Object> get props => [error];
}
