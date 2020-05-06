import 'package:meta/meta.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
class SortState {

  final SortFields tempSortField;
  final SortDirections tempSortDirection;

  SortState({
    @required SortFields tempSortField,
    @required SortDirections tempSortDirection
  }) : tempSortField = tempSortField ?? SortFields.DATEMODIFIED,
       tempSortDirection = tempSortDirection ?? SortDirections.ASC;

  SortState copyWith({
    SortFields tempSortField,
    SortDirections tempSortDirection
  }){
    return SortState(
        tempSortField: tempSortField ?? this.tempSortField,
        tempSortDirection: tempSortDirection ?? this.tempSortDirection
    );
  }

  SortState update({
    SortFields tempSortField,
    SortDirections tempSortDirection
  }){
    return copyWith(
        tempSortField: tempSortField,
        tempSortDirection: tempSortDirection
    );
  }

  @override
  List<Object> get props => [];
}

class InitialSortBlocState extends SortState {}


