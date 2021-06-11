import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/repository/firebase_profile_repository.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

part 'tripdetails_event.dart';
part 'tripdetails_state.dart';

class TripDetailsBloc extends Bloc<TripDetailsEvent, TripDetailsState> {
  final TripsRepository _tripsRepository;
  final ProfileRepository _profileRepository;
  StreamSubscription _profileSubscription;
  
  TripDetailsBloc(TripsRepository tripsRepository) : 
  _tripsRepository = tripsRepository ?? new FirebaseTripsRepository(),
  _profileRepository = new FirebaseProfileRepository(),
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

  Stream<TripDetailsState> _mapGetTripDetailsToState(
      GetTripDetails event) async* {
    Trip trip = await _tripsRepository.getTripById(event.tripId);

    _profileSubscription?.cancel();
    
    _profileSubscription = _profileRepository.familyMembers().listen(
      (members) => add(UpdateTripDetailsSuccess(members, trip))
    );    
  }

  Stream<TripDetailsState> _mapDeleteTripToState(
      DeleteTripClicked event) async* {
    await _tripsRepository.deleteTrip(event.tripId);
  }

}
