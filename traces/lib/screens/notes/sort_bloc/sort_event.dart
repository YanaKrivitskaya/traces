import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/notes/note.dart';

@immutable
abstract class SortEvent extends Equatable{
  const SortEvent();
}

class SortUpdated extends SortEvent{
  final SortFields sortField;
  final SortDirections sortDirection;

  SortUpdated(
      this.sortField,
      this.sortDirection,
      );

  @override
  List<Object> get props => [sortField, sortDirection];

  @override
  String toString() => '''
  SortUpdated { 
    sortField: $sortField,
    sortDirection: $sortDirection    
  }''';
}

class SortTempFieldUpdated extends SortEvent{

  final SortFields tempSortField;

  SortTempFieldUpdated(this.tempSortField);

  @override
  List<Object> get props => [tempSortField];

  @override
  String toString() => '''
  SortUpdated {     
    tempSortField: $tempSortField
    
  }''';
}

class SortTempDirectionUpdated extends SortEvent{

  final SortDirections tempSortDirection;

  SortTempDirectionUpdated(this.tempSortDirection);

  @override
  List<Object> get props => [tempSortDirection];

  @override
  String toString() => '''
  SortUpdated {     
    tempSortDirection: $tempSortDirection    
  }''';
}
