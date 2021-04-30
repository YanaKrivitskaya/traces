import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

part 'startplanning_event.dart';
part 'startplanning_state.dart';

class StartPlanningBloc extends Bloc<StartPlanningEvent, StartPlanningState> {
  final TripsRepository _tripsRepository;
  
  StartPlanningBloc(TripsRepository tripsRepository) : 
  _tripsRepository = tripsRepository ?? new FirebaseTripsRepository(),
  super(StartPlanningInitial());

  @override
  Stream<StartPlanningState> mapEventToState(StartPlanningEvent event) async* {
    if (event is NewTripMode) {
      yield* _mapNewTripModeToState(event);
    } else if (event is DateRangeUpdated) {
      yield* _mapDateRangeUpdatedToState(event);
    } else if (event is StartPlanningSubmitted) {
      yield* _mapStartPlanningSubmittedToState(event);
    }
  }

  Stream<StartPlanningState> _mapNewTripModeToState(NewTripMode event) async* {
    
    /*UserSettings userSettings = await _visasRepository.userSettings();
    VisaSettings settings = await _visasRepository.settings();*/
    /*var userProfile = await _profileRepository.getCurrentProfile();
    List<String> members = userProfile.familyMembers;

    members.add(userProfile.displayName);*/

    yield StartPlanningSuccessState(null);
  }

  Stream<StartPlanningState> _mapDateRangeUpdatedToState(DateRangeUpdated event) async* {
    
    Trip trip = (state as StartPlanningSuccessState).trip ?? new Trip();

    trip.startDate = event.startDate;
    trip.endDate = event.endDate;


    yield StartPlanningSuccessState(trip);
  }

  Stream<StartPlanningState> _mapStartPlanningSubmittedToState(StartPlanningSubmitted event) async* {
 
    print(inspect(event.trip));

    Trip trip = await _tripsRepository.addnewTrip(event.trip)
    .timeout(Duration(seconds: 3), onTimeout: (){return event.trip;});

    if(trip != null){
      yield StartPlanningSuccessState(trip);
    }

    //yield StartPlanningErrorState("Trip can't be null");
  }

}
