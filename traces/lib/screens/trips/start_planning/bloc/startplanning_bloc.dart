import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../utils/api/customException.dart';
import '../../../profile/model/group_model.dart';
import '../../../profile/repository/api_profile_repository.dart';
import '../../model/trip.model.dart';
import '../../repository/api_trips_repository.dart';

part 'startplanning_event.dart';
part 'startplanning_state.dart';

class StartPlanningBloc extends Bloc<StartPlanningEvent, StartPlanningState> {
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository;
  
  StartPlanningBloc() : 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
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

    Trip updTrip = trip.copyWith(startDate: event.startDate, endDate: event.endDate);

    yield StartPlanningSuccessState(updTrip, false);
  }

  Stream<StartPlanningState> _mapStartPlanningSubmittedToState(StartPlanningSubmitted event) async* {
    yield StartPlanningSuccessState(event.trip, true);

    if(event.trip!.startDate == null || event.trip!.endDate == null){
      var error = 'Please choose the dates';
      yield StartPlanningErrorState(event.trip, error);
    }
    else{
      try{
        var profile = await _profileRepository.getProfileWithGroups();      
        var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

        Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
        event.trip!.users = [family.users.firstWhere((u) => u.accountId == profile.accountId)];

        Trip trip = await _tripsRepository.createTrip(event.trip!, profile.accountId);        

        yield StartPlanningCreatedState(trip);
      } on CustomException catch(e){
        
      }
      
    }    
  }

}
