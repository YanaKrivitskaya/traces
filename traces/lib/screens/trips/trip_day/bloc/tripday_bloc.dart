import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';
import 'package:traces/screens/trips/model/trip_object.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';

part 'tripday_event.dart';
part 'tripday_state.dart';

class TripDayBloc extends Bloc<TripDayEvent, TripDayState> {
  final ApiTripsRepository _tripsRepository; 
  
  TripDayBloc() 
  : _tripsRepository = new ApiTripsRepository(),
  super(TripDayInitial(null));

  @override
  Stream<TripDayState> mapEventToState(
    TripDayEvent event,
  ) async* {
    if (event is TripDayLoaded) {
      yield* _mapTripDayLoadedToState(event);
    }
  }

  Stream<TripDayState> _mapTripDayLoadedToState(TripDayLoaded event) async* {
    //var day = await _tripsRepository.getTripDay(event.tripDay.tripId, event.tripDay.date);
    yield TripDaySuccess(event.tripDay);
  }
}
