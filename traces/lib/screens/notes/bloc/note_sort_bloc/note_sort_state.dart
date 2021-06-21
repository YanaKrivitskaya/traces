import '../../models/note.model.dart';


class NoteSortState {
  final SortFields tempSortField;
  final SortDirections tempSortDirection;

  NoteSortState({
    required SortFields tempSortField,
    required SortDirections tempSortDirection,
  }) : tempSortField = tempSortField,
        tempSortDirection = tempSortDirection;

  NoteSortState update({
    SortFields? tempSortField,
    SortDirections? tempSortDirection
  }){
    return copyWith(
        tempSortField: tempSortField,
        tempSortDirection: tempSortDirection
    );
  }

  NoteSortState copyWith({
    SortFields? tempSortField,
    SortDirections? tempSortDirection
  }){
    return NoteSortState(
        tempSortField: tempSortField ?? this.tempSortField,
        tempSortDirection: tempSortDirection ?? this.tempSortDirection
    );
  }
}

class InitialNoteSortState extends NoteSortState {
  InitialNoteSortState() : super(tempSortDirection:  SortDirections.ASC, tempSortField:  SortFields.DATEMODIFIED);
}
