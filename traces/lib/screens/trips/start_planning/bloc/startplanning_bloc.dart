import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/repository/__firebase_profile_repository.dart';
import 'package:traces/screens/profile/repository/__profile_repository.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

part 'startplanning_event.dart';
part 'startplanning_state.dart';

class StartPlanningBloc extends Bloc<StartPlanningEvent, StartPlanningState> {
  /*final TripsRepository _tripsRepository;
  final ProfileRepository _profileRepository;*/
  
  StartPlanningBloc(/*TripsRepository tripsRepository*/) : 
  /*_tripsRepository = tripsRepository ?? new FirebaseTripsRepository(),
  _profileRepository = new FirebaseProfileRepository(),*/
  super(StartPlanningInitial(null));

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
    yield StartPlanningSuccessState(new Trip(), false);
  }

  Stream<StartPlanningState> _mapDateRangeUpdatedToState(DateRangeUpdated event) async* {
    
    Trip trip = state.trip ?? new Trip();

    trip.startDate = event.startDate;
    trip.endDate = event.endDate;

    yield StartPlanningSuccessState(trip, false);
  }

  Stream<StartPlanningState> _mapStartPlanningSubmittedToState(StartPlanningSubmitted event) async* {
    yield StartPlanningSuccessState(event.trip, true);

    if(event.trip!.startDate == null || event.trip!.endDate == null){
      var error = 'Please choose the dates';
      yield StartPlanningErrorState(event.trip, error);
    }
    else{
      /*var userProfile = await _profileRepository.getCurrentProfile(); 
      event.trip!.tripMembers = [userProfile.displayName];

      Trip trip = await _tripsRepository.addnewTrip(event.trip)
      .timeout(Duration(seconds: 5), onTimeout: (){
          print("have timeout");
          return event.trip!;
        });

      if(trip != null && trip.id != null){
        yield StartPlanningCreatedState(trip);
      }*/
    }    
  }

}
