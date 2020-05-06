import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/notes/note.dart';
import './bloc.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  @override
  SortState get initialState => InitialSortBlocState();

  @override
  Stream<SortState> mapEventToState(
    SortEvent event,
  ) async* {
    if( event is SortUpdated){
      yield*_mapSortUpdatedToState(event);
    }
    else if( event is SortTempFieldUpdated){
      yield* _mapSortTempFieldUpdatedToState(event);
    }
    else if(event is SortTempDirectionUpdated){
      yield* _mapSortTempDirectionUpdatedToState(event);
    }
  }

  Stream<SortState> _mapSortTempFieldUpdatedToState(SortTempFieldUpdated event) async*{
    yield state.update(
        tempSortField: event.tempSortField
    );
  }

  Stream<SortState> _mapSortTempDirectionUpdatedToState(SortTempDirectionUpdated event) async*{
    yield state.update(
        tempSortDirection: event.tempSortDirection
    );
  }

  Stream<SortState> _mapSortUpdatedToState(SortUpdated event) async*{
    yield state.update(
        tempSortField: event.sortField,
        tempSortDirection: event.sortDirection
    );
  }
}
