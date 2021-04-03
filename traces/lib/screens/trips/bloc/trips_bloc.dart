import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc() : super(TripsInitial());

  @override
  Stream<TripsState> mapEventToState(
    TripsEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
