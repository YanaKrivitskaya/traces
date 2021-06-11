import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/repository/firebase_profile_repository.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/repository/firebase_trips_repository.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';


part 'tripmembers_event.dart';
part 'tripmembers_state.dart';

class TripMembersBloc extends Bloc<TripMembersEvent, TripMembersState>{
  final TripsRepository _tripsRepository;
  final ProfileRepository _profileRepository;
  StreamSubscription _profileSubscription;

  TripMembersBloc(): 
  _tripsRepository = new FirebaseTripsRepository(),
  _profileRepository = new FirebaseProfileRepository(),
  super(LoadingTripMembersState());

  @override
  Stream<TripMembersState> mapEventToState(TripMembersEvent event) async* {
    if(event is GetMembers){
      yield* _mapGetTripMembersToState(event);
    } else if(event is UpdateTripMembersSuccess){
      yield* _mapUpdateTripMembersToSuccessState(event);
    }else if(event is MemberChecked){
      yield* _mapUpdateMemberCheckedToState(event);
    }else if(event is SubmitTripMembers){
      yield* _mapSubmitTripMembersToState(event);
    }  
  }

  Stream<TripMembersState> _mapUpdateTripMembersToSuccessState(
      UpdateTripMembersSuccess event) async* {
    yield SuccessTripMembersState(
      event.members,
      event.selectedMembers
    );
  }

  Stream<TripMembersState> _mapGetTripMembersToState(GetMembers event) async*{
    var trip = await _tripsRepository.getTripById(event.tripId);

    List<String> selectedMembers = List.empty(growable: true);

    _profileSubscription?.cancel();
    _profileSubscription = _profileRepository.familyMembers().listen(
      (members) {
        members.forEach((m) {
              if(trip.tripMembers.contains(m.id)){
                selectedMembers.add(m.id);
              }
            });
        add(UpdateTripMembersSuccess(members, selectedMembers));
      } 
    );
  }

  Stream<TripMembersState> _mapUpdateMemberCheckedToState(MemberChecked event) async*{
   
    if (state.selectedMembers.contains(event.memberId)){
      state.selectedMembers.remove(event.memberId);
    }else{
      state.selectedMembers.add(event.memberId);
    }

    yield SuccessTripMembersState(
      state.members,
      state.selectedMembers
    );
  }

  Stream<TripMembersState> _mapSubmitTripMembersToState(SubmitTripMembers event) async*{

    yield LoadingTripMembersState();
   
    await _tripsRepository.updateTripMembers(event.tripId, event.selectedMembers);

    yield SubmittedTripMembersState(
      state.members,
      state.selectedMembers
    );
  }

}