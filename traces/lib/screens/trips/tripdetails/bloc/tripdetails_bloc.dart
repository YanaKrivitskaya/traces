import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/group_model.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
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
  super(TripDetailsInitial());

  @override
  Stream<TripDetailsState> mapEventToState(TripDetailsEvent event) async* {
    if (event is GetTripDetails) {
      yield* _mapGetTripDetailsToState(event);
    } else if (event is UpdateTripDetailsSuccess){
      yield* _mapUpdateTripDetailsToSuccessState(event);
    } else if (event is DeleteTripClicked){
      yield* _mapDeleteTripToState(event);
    }
  }

  Stream<TripDetailsState> _mapUpdateTripDetailsToSuccessState(
      UpdateTripDetailsSuccess event) async* {
    yield TripDetailsSuccessState(     
      event.trip,
      event.members,
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
        );
      }      
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString());
    }
      
  }

  Stream<TripDetailsState> _mapDeleteTripToState(DeleteTripClicked event) async* {
    try{
      await _tripsRepository.deleteTrip(event.tripId);
      yield TripDetailsDeleted();
    }on CustomException catch(e){
      yield TripDetailsErrorState(e.toString());
    }    
    
  }

}
