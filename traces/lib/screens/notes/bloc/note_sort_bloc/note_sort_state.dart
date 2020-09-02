import 'package:traces/screens/notes/model/note.dart';
import 'package:meta/meta.dart';

class NoteSortState {
  final SortFields tempSortField;
  final SortDirections tempSortDirection;
  //final StateStatus status;

  NoteSortState({
    @required SortFields tempSortField,
    @required SortDirections tempSortDirection,
    //@required this.status
  }) : tempSortField = tempSortField ?? SortFields.DATEMODIFIED,
        tempSortDirection = tempSortDirection ?? SortDirections.ASC;

  NoteSortState update({
    SortFields tempSortField,
    SortDirections tempSortDirection,
    //StateStatus stateStatus
  }){
    return copyWith(
        tempSortField: tempSortField,
        tempSortDirection: tempSortDirection,
        //stateStatus: stateStatus
    );
  }

  NoteSortState copyWith({
    SortFields tempSortField,
    SortDirections tempSortDirection,
    //StateStatus stateStatus
  }){
    return NoteSortState(
        tempSortField: tempSortField ?? this.tempSortField,
        tempSortDirection: tempSortDirection ?? this.tempSortDirection,
        //status: stateStatus ?? this.status
    );
  }
}

class InitialNoteSortState extends NoteSortState {}
