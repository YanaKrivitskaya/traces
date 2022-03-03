import 'package:bloc/bloc.dart';

import 'bloc.dart';

class NoteSortBloc extends Bloc<NoteSortEvent, NoteSortState> {
  NoteSortBloc() : super(InitialNoteSortState()){
    on<SortUpdated>(_onSortUpdated);
    on<SortTempFieldUpdated>(_onSortTempFieldUpdated);
    on<SortTempDirectionUpdated>(_onSortTempDirectionUpdated);
  }

  void _onSortTempFieldUpdated(SortTempFieldUpdated event, Emitter<NoteSortState> emit) async{
    return emit(state.update(
        tempSortField: event.tempSortField
    ));
  }

  void _onSortTempDirectionUpdated(SortTempDirectionUpdated event, Emitter<NoteSortState> emit) async{
    return emit(state.update(
        tempSortDirection: event.tempSortDirection
    ));
  }

  void _onSortUpdated(SortUpdated event, Emitter<NoteSortState> emit) async{
    return emit(state.update(
        tempSortField: event.sortField,
        tempSortDirection: event.sortDirection
    ));
  }
}
