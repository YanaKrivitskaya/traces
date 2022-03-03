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
          super(ProfileState.empty()){
            on<GetProfile>(_onGetProfile);
            on<UsernameChanged>(_onUsernameChanged);
            on<UsernameUpdated>(_onUsernameUpdated);
            on<FamilyUpdated>(_onFamilyUpdated);
            on<ShowFamilyDialog>(_onShowFamilyDialog);
            on<UserRemovedFromGroup>(_onUserRemovedFromGroup);
          }

  void _onUsernameChanged(UsernameChanged event, Emitter<ProfileState> emit) async{
    return emit(state.update(
        isUsernameValid: Validator.isValidUsername(event.username),
        exception: null,
        mode: StateMode.Edit
    ));
  } 

  void _onShowFamilyDialog(ShowFamilyDialog event, Emitter<ProfileState> emit) async{
    return emit(state.update(
      exception: null,
      mode: StateMode.View
    ));
  }

  void _onUsernameUpdated(UsernameUpdated event, Emitter<ProfileState> emit) async{
    ProfileState currentState = state;
    emit(ProfileState.loading());

    GroupUser user = GroupUser(name: event.username, userId: event.userId);

    try{
      user = await profileRepository.updateUser(user);

      Profile profile = currentState.profile!.copyWith(name: user.name);

      return emit(ProfileState.success(profile: profile));
    }on CustomException catch(e){      
      return emit(ProfileState.failure(profile: currentState.profile, exception: e));
    }
  }

  void _onFamilyUpdated(FamilyUpdated event, Emitter<ProfileState> emit) async{
    ProfileState currentState = state;
    emit(ProfileState.loading());

    GroupUser user = GroupUser(name: event.name, userId: event.userId);

    try{
      if(event.userId != null) user = await profileRepository.updateUser(user);
      else user = await profileRepository.createUser(user, event.groupId);

      var group = await profileRepository.getGroupUsers(event.groupId);

      var groupIndex = currentState.profile!.groups!.indexWhere((g) => g.id == group.id);

      currentState.profile!.groups![groupIndex] = group;     

      return emit(ProfileState.success(profile: currentState.profile));
    } on CustomException catch(e){      
      return emit(ProfileState.failure(profile: currentState.profile, exception: e));
    }
  }  

  void _onGetProfile(GetProfile event, Emitter<ProfileState> emit) async{
    ProfileState currentState = state;
    emit(ProfileState.loading());

   try{
      Profile profile = await profileRepository.getProfileWithGroups();    

      return emit(ProfileState.success(profile: profile));
   }on CustomException catch(e){      
      return emit(ProfileState.failure(profile: currentState.profile, exception: e));
    }    
  }

  void _onUserRemovedFromGroup(UserRemovedFromGroup event, Emitter<ProfileState> emit) async{
    ProfileState currentState = state;
    emit(ProfileState.loading());

    try{
      var group = await profileRepository.removeUserFromGroup(event.user.userId!, event.group.id!);
      var groupIndex = currentState.profile!.groups!.indexWhere((g) => g.id == group.id);

      currentState.profile!.groups![groupIndex] = group;

      return emit(ProfileState.success(profile: currentState.profile));
    }on CustomException catch(e){      
      return emit(ProfileState.failure(profile: currentState.profile, exception: e));
    }    
  }
}
