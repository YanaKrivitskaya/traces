import 'package:meta/meta.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/group_model.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'tripmembers_event.dart';
part 'tripmembers_state.dart';

class TripMembersBloc extends Bloc<TripMembersEvent, TripMembersState>{
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository; 

  TripMembersBloc(): 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(LoadingTripMembersState());

  @override
  Stream<TripMembersState> mapEventToState(TripMembersEvent event) async* {
    if(event is GetMembers){
      yield* _mapGetTripMembersToState(event);
    } else if(event is MemberChecked){
      yield* _mapUpdateMemberCheckedToState(event);
    }else if(event is SubmitTripMembers){
      yield* _mapSubmitTripMembersToState(event);
    }  
  } 

  Stream<TripMembersState> _mapGetTripMembersToState(GetMembers event) async*{
    try{
      Trip? trip = await _tripsRepository.getTripById(event.tripId!);

      if(trip != null){
        List<int> selectedMembers = List.empty(growable: true);

        var profile = await _profileRepository.getProfileWithGroups();      
        var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

        Group family = await _profileRepository.getGroupUsers(familyGroup.id!);

        family.users.forEach((m) {
          if(trip.users!.contains(m)){
            selectedMembers.add(m.userId!);
          }
        });

        yield SuccessTripMembersState(
          family.users,
          selectedMembers
        );
      }   
    }on CustomException catch(e){
        
    }  
    
  }

  Stream<TripMembersState> _mapUpdateMemberCheckedToState(MemberChecked event) async*{
   
    if (state.selectedMembers != null && state.selectedMembers!.contains(event.memberId)){
      state.selectedMembers!.remove(event.memberId);
    }else{
      state.selectedMembers!.add(event.memberId!);
    }

    yield SuccessTripMembersState(
      state.members,
      state.selectedMembers
    );
  }

  Stream<TripMembersState> _mapSubmitTripMembersToState(SubmitTripMembers event) async*{

    yield LoadingTripMembersState();
   
    await _tripsRepository.updateTripUsers(event.tripId, event.selectedMembers!);

    yield SubmittedTripMembersState(
      state.members,
      state.selectedMembers
    );
  }

}