import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';
import 'package:meta/meta.dart';

class NoteSortState extends Equatable {
  final SortFields tempSortField;
  final SortDirections tempSortDirection;

  NoteSortState({
    @required SortFields tempSortField,
    @required SortDirections tempSortDirection
  }) : tempSortField = tempSortField ?? SortFields.DATEMODIFIED,
        tempSortDirection = tempSortDirection ?? SortDirections.ASC;

  @override
  List<Object> get props => [];

  NoteSortState update({
    SortFields tempSortField,
    SortDirections tempSortDirection
  }){
    return copyWith(
        tempSortField: tempSortField,
        tempSortDirection: tempSortDirection
    );
  }

  NoteSortState copyWith({
    SortFields tempSortField,
    SortDirections tempSortDirection
  }){
    return NoteSortState(
        tempSortField: tempSortField ?? this.tempSortField,
        tempSortDirection: tempSortDirection ?? this.tempSortDirection
    );
  }
}

class InitialNoteSortState extends NoteSortState {}
