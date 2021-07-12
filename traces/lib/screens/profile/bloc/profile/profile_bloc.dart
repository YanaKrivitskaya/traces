import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:traces/utils/api/customException.dart';

import '../../../../utils/helpers/validation_helper.dart';
import '../../../../utils/misc/state_types.dart';
import '../../model/group_user_model.dart';
import '../../model/profile_model.dart';
import '../../repository/api_profile_repository.dart';
import 'bloc.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
    final ApiProfileRepository profileRepository;

    ProfileBloc()
        : profileRepository = new ApiProfileRepository(),
          super(ProfileState.empty());
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfile) {
      yield* _mapGetProfileToState(event);
    } else if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    }
    else if (event is UsernameUpdated) {
      yield* _mapUsernameUpdatedToState(event);
    }
    else if (event is FamilyUpdated) {
      yield* _mapGroupMemberUpdatedToState(event);
    }
    else if (event is ShowFamilyDialog) {
      yield* _mapShowFamilyDialogToState();
    }else if (event is UserRemovedFromGroup) {
      yield* _mapUserRemovedFromGroupToState(event);
    }
  }

  Stream<ProfileState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isUsernameValid: Validator.isValidUsername(username),
        exception: null,
        mode: StateMode.Edit
    );
  }

  Stream<ProfileState> _mapShowFamilyDialogToState() async*{
    yield state.update(
      exception: null,
      mode: StateMode.View
    );
  }

  Stream<ProfileState> _mapUsernameUpdatedToState(UsernameUpdated event) async*{

    ProfileState currentState = state;
    yield ProfileState.loading();

    GroupUser user = GroupUser(name: event.username, userId: event.userId);

    try{
      user = await profileRepository.updateUser(user);

      Profile profile = currentState.profile!.copyWith(name: user.name);

      yield ProfileState.success(profile: profile);
    }on CustomException catch(e){      
      yield ProfileState.failure(profile: currentState.profile, exception: e);
    }
    
  }

  Stream<ProfileState> _mapGroupMemberUpdatedToState(FamilyUpdated event) async*{
    ProfileState currentState = state;
    yield ProfileState.loading();

    GroupUser user = GroupUser(name: event.name, userId: event.userId);

    try{
      if(event.userId != null) user = await profileRepository.updateUser(user);
      else user = await profileRepository.createUser(user, event.groupId);

      var group = await profileRepository.getGroupUsers(event.groupId);

      var groupIndex = currentState.profile!.groups!.indexWhere((g) => g.id == group.id);

      currentState.profile!.groups![groupIndex] = group;     

      yield ProfileState.success(profile: currentState.profile);
    } on CustomException catch(e){      
      yield ProfileState.failure(profile: currentState.profile, exception: e);
    }
  }  

  Stream<ProfileState> _mapGetProfileToState(GetProfile event) async*{
    ProfileState currentState = state;
   yield ProfileState.loading();

   try{
      Profile profile = await profileRepository.getProfileWithGroups();    

      yield ProfileState.success(profile: profile);
   }on CustomException catch(e){      
      yield ProfileState.failure(profile: currentState.profile, exception: e);
    }   
  }

  Stream<ProfileState> _mapUserRemovedFromGroupToState(UserRemovedFromGroup event) async*{
    ProfileState currentState = state;
    yield ProfileState.loading();

    try{
      var group = await profileRepository.removeUserFromGroup(event.user.userId!, event.group.id!);
      var groupIndex = currentState.profile!.groups!.indexWhere((g) => g.id == group.id);

      currentState.profile!.groups![groupIndex] = group;

      yield ProfileState.success(profile: currentState.profile);
    }on CustomException catch(e){      
      yield ProfileState.failure(profile: currentState.profile, exception: e);
    }    
  }
}
