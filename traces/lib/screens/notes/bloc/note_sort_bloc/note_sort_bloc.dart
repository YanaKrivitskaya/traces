import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class NoteSortBloc extends Bloc<NoteSortEvent, NoteSortState> {
  NoteSortBloc() : super(InitialNoteSortState());

  @override
  NoteSortState get initialState => InitialNoteSortState();

  @override
  Stream<NoteSortState> mapEventToState(
    NoteSortEvent event,
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

  Stream<NoteSortState> _mapSortTempFieldUpdatedToState(SortTempFieldUpdated event) async*{
    /*yield state.update(stateStatus: StateStatus.Loading);*/

    yield state.update(
        /*stateStatus: StateStatus.Success,*/
        tempSortField: event.tempSortField
    );
  }

  Stream<NoteSortState> _mapSortTempDirectionUpdatedToState(SortTempDirectionUpdated event) async*{
    //yield state.update(stateStatus: StateStatus.Loading);

    yield state.update(
        /*stateStatus: StateStatus.Success,*/
        tempSortDirection: event.tempSortDirection
    );
  }

  Stream<NoteSortState> _mapSortUpdatedToState(SortUpdated event) async*{
    yield state.update(
        /*stateStatus: StateStatus.Success,*/
        tempSortField: event.sortField,
        tempSortDirection: event.sortDirection
    );
  }
}
