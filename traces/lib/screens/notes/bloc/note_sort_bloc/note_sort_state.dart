import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/model/note.dart';
import 'package:meta/meta.dart';

class NoteSortState {
  final SortFields tempSortField;
  final SortDirections tempSortDirection;
  final bool isLoading;
  final bool isSuccess;

  NoteSortState({
    @required SortFields tempSortField,
    @required SortDirections tempSortDirection,
    @required this.isLoading,
    @required this.isSuccess
  }) : tempSortField = tempSortField ?? SortFields.DATEMODIFIED,
        tempSortDirection = tempSortDirection ?? SortDirections.ASC;

  NoteSortState update({
    SortFields tempSortField,
    SortDirections tempSortDirection,
    bool isLoading,
    bool isSuccess
  }){
    return copyWith(
        tempSortField: tempSortField,
        tempSortDirection: tempSortDirection,
        isLoading: isLoading,
        isSuccess: isSuccess
    );
  }

  NoteSortState copyWith({
    SortFields tempSortField,
    SortDirections tempSortDirection,
    bool isLoading,
    bool isSuccess
  }){
    return NoteSortState(
        tempSortField: tempSortField ?? this.tempSortField,
        tempSortDirection: tempSortDirection ?? this.tempSortDirection,
        isLoading: isLoading ?? isLoading,
        isSuccess: isSuccess ?? isSuccess
    );
  }
}

class InitialNoteSortState extends NoteSortState {}
