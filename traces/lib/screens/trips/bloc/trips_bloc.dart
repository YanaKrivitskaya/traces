import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';
import '../model/trip.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  //final TripsRepository _tripsRepository;
  StreamSubscription? _tripsSubscription;

  TripsBloc(/*TripsRepository tripsRepository*/) 
  : //_tripsRepository = tripsRepository ?? new FirebaseTripsRepository(),
    super(TripsInitial());

  @override
  Stream<TripsState> mapEventToState(TripsEvent event) async* {
    if (event is GetAllTrips) {
      yield* _mapGetTripsToState(event);
    } else if (event is UpdateTripsList) {
      yield* mapUpdateTripsListToState(event);
    }
  }

  Stream<TripsState> mapUpdateTripsListToState(UpdateTripsList event) async*{
    yield TripsSuccessState(event.trips);
  }

  Stream<TripsState> _mapGetTripsToState(GetAllTrips event) async*{
    _tripsSubscription?.cancel();

   /* _tripsSubscription = _tripsRepository.trips().listen(
      (trips) => add(UpdateTripsList(trips))
    );*/
  }
}
