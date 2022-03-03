import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/api/customException.dart';
import '../../../../profile/model/group_model.dart';
import '../../../../profile/model/group_user_model.dart';
import '../../../../profile/repository/api_profile_repository.dart';
import '../../../model/trip.model.dart';
import '../../../repository/api_trips_repository.dart';

part 'tripmembers_event.dart';
part 'tripmembers_state.dart';

class TripMembersBloc extends Bloc<TripMembersEvent, TripMembersState>{
  final ApiTripsRepository _tripsRepository;
  final ApiProfileRepository _profileRepository; 

  TripMembersBloc(): 
  _tripsRepository = new ApiTripsRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(LoadingTripMembersState()){
    on<GetMembers>(_onGetMembers);
    on<MemberChecked>(_onMemberChecked);
    on<SubmitTripMembers>(_onSubmitTripMembers);
  }

  void _onGetMembers(GetMembers event, Emitter<TripMembersState> emit) async{
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

        emit(SuccessTripMembersState(
          family.users,
          selectedMembers
        ));
      }   
    }on CustomException catch(e){
        
    }
  } 

  void _onMemberChecked(MemberChecked event, Emitter<TripMembersState> emit) async{
    if (state.selectedMembers != null && state.selectedMembers!.contains(event.memberId)){
      state.selectedMembers!.remove(event.memberId);
    }else{
      state.selectedMembers!.add(event.memberId!);
    }

    emit(SuccessTripMembersState(
      state.members,
      state.selectedMembers
    ));
  } 

  void _onSubmitTripMembers(SubmitTripMembers event, Emitter<TripMembersState> emit) async{
    emit(LoadingTripMembersState());
   
    await _tripsRepository.updateTripUsers(event.tripId, event.selectedMembers!);

    emit(SubmittedTripMembersState(
      state.members,
      state.selectedMembers
    ));
  } 
}