import 'package:equatable/equatable.dart';

import '../../model/note.model.dart';

abstract class NoteSortEvent extends Equatable {
  const NoteSortEvent();
}

class SortUpdated extends NoteSortEvent{
  final SortFields sortField;
  final SortDirections sortDirection;

  SortUpdated(
      this.sortField,
      this.sortDirection,
      );

  @override
  List<Object> get props => [sortField, sortDirection];
}

class SortTempFieldUpdated extends NoteSortEvent{
  final SortFields tempSortField;

  SortTempFieldUpdated(this.tempSortField);

  @override
  List<Object> get props => [tempSortField];

}

class SortTempDirectionUpdated extends NoteSortEvent{
  final SortDirections tempSortDirection;

  SortTempDirectionUpdated(this.tempSortDirection);

  @override
  List<Object> get props => [tempSortDirection];

}
