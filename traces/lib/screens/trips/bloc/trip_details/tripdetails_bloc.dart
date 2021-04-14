import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

part 'tripdetails_event.dart';
part 'tripdetails_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final TripsRepository _tripsRepository;
  
  TripDetailsBloc(TripsRepository tripsRepository) : 
  _tripsRepository = tripsRepository ?? new FirebaseTripsRepository(),
  super(TripDetailsInitial());

  @override
  Stream<TripDetailsState> mapEventToState(TripDetailsEvent event) async* {
    if (event is NewTripMode) {
      yield* _mapNewTripModeToState(event);
    }
  }

  Stream<TripDetailsState> _mapNewTripModeToState(NewTripMode event) async* {
    
    /*UserSettings userSettings = await _visasRepository.userSettings();
    VisaSettings settings = await _visasRepository.settings();*/
    /*var userProfile = await _profileRepository.getCurrentProfile();
    List<String> members = userProfile.familyMembers;

    members.add(userProfile.displayName);*/

    yield TripDetailsSuccessState(null);
  }

}
