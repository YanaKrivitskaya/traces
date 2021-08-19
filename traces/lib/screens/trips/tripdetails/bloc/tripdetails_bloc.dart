import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/group_model.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_details_tab.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'tripdetails_event.dart';
part 'tripdetails_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository;
  
  TripDetailsBloc() : 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(TripDetailsInitial(0));

  @override
  Stream<TripDetailsState> mapEventToState(TripDetailsEvent event) async* {
    if (event is GetTripDetails) {
      yield* _mapGetTripDetailsToState(event);
    } else if (event is UpdateTripDetailsSuccess){
      yield* _mapUpdateTripDetailsToSuccessState(event);
    } else if (event is DeleteTripClicked){
      yield* _mapDeleteTripToState(event);
    } else if (event is TabUpdated) {
      yield* _mapTabUpdatedToState(event);
    }
  }

  Stream<TripDetailsState> _mapUpdateTripDetailsToSuccessState(
      UpdateTripDetailsSuccess event) async* {
    yield TripDetailsSuccessState(     
      event.trip,
      event.members,
      state.activeTab
    );
  }

  Stream<TripDetailsState> _mapGetTripDetailsToState(GetTripDetails event) async* {
    try{
      Trip? trip = await _tripsRepository.getTripById(event.tripId);
      var profile = await _profileRepository.getProfileWithGroups();      
      var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

      Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
      
      if(trip != null){
        yield TripDetailsSuccessState(     
          trip,
          family.users,
          0
        );
      }      
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }
      
  }

  Stream<TripDetailsState> _mapDeleteTripToState(DeleteTripClicked event) async* {
    try{
      await _tripsRepository.deleteTrip(event.tripId);
      yield TripDetailsDeleted(state.activeTab);
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString(), state.activeTab);
    }    
  }

  Stream<TripDetailsState> _mapTabUpdatedToState(TabUpdated event) async* {
    yield TripDetailsSuccessState(     
      state.trip!,
      state.familyMembers!,
      event.tab
    ); 
    
  }

}
