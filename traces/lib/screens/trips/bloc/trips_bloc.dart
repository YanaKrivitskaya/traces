import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final ApiTripsRepository _tripsRepository;
 
  TripsBloc() 
  : _tripsRepository = new ApiTripsRepository(),
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
    yield TripsLoadingState();
    try{
      var trips = await _tripsRepository.getTrips();
      yield TripsSuccessState(trips);
    } on CustomException catch(e){
      //yield T(error: e);
    }  
  }
}
