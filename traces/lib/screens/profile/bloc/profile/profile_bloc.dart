import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:traces/shared/state_types.dart';
import 'package:traces/shared/validator.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription _profileSubscription;

  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository, super(ProfileState.empty());
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is GetProfile) {
      yield* _mapGetProfileToState(event);
    } else if (event is UpdateProfileState) {
      yield* _mapUpdateProfileStateToState(event);
    }else if (event is UsernameChanged) {
      yield* _mapUsernameChangedToState(event.username);
    }
    else if (event is UsernameUpdated) {
      yield* _mapUsernameUpdatedToState(event.username);
    }
    else if (event is FamilyUpdated) {
      yield* _mapFamilyMemberUpdatedToState(event.id, event.name);
    }
    else if (event is ShowFamilyDialog) {
      yield* _mapShowFamilyDialogToState();
    }
  }

  Stream<ProfileState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isUsernameValid: Validator.isValidUsername(username),
        mode: StateMode.Edit
    );
  }

  Stream<ProfileState> _mapShowFamilyDialogToState() async*{
    yield state.update(
        mode: StateMode.View
    );
  }

  Stream<ProfileState> _mapUsernameUpdatedToState(String username) async*{

    await _profileRepository.updateUsername(username);

    Profile profile = Profile(state.profile.email, displayName: username, isEmailVerified: state.profile.isEmailVerified);

    Profile updProfile = await _profileRepository.updateProfile(profile);

    yield state.update(profile: updProfile);
  }

  Stream<ProfileState> _mapFamilyMemberUpdatedToState(String id, String name) async*{

    Member updMember = Member(name: name);
    if(id != null){
      updMember.id = id;
      await _profileRepository.updateMember(updMember);   
    }

    await _profileRepository.addNewMember(updMember);        

    yield state.update(profile: state.profile);
  }

  Stream<ProfileState> _mapUpdateProfileStateToState(UpdateProfileState event) async* {
    yield ProfileState.success(profile: event.profile, members: event.familyMembers);
  }

  Stream<ProfileState> _mapGetProfileToState(GetProfile event) async*{
    yield ProfileState.loading();

    Profile profile = await _profileRepository.getCurrentProfile();

    if(profile == null){
      profile = await _profileRepository.addNewProfile();
    }

    _profileSubscription?.cancel();

    _profileSubscription = _profileRepository.familyMembers().listen(
      (members) => add(UpdateProfileState(members, profile))
    );    

    //yield ProfileState.success(profile: profile);
  }

}
