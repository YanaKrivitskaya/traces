import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/loginSignup/validator.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository, super(null);

  @override
  ProfileState get initialState => ProfileState.empty();

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
      yield* _mapFamilyMemberUpdatedToState(event.name, event.position);
    }
  }

  Stream<ProfileState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isUsernameValid: LoginSignupValidator.isValidUsername(username),
        isEditing: true
    );
  }

  Stream<ProfileState> _mapUsernameUpdatedToState(String username) async*{

    await _profileRepository.updateUsername(username);

    Profile profile = Profile(state.profile.email, state.profile.familyMembers, displayName: username, isEmailVerified: state.profile.isEmailVerified);

    Profile updProfile = await _profileRepository.updateProfile(profile);

    yield state.update(profile: updProfile);
  }

  Stream<ProfileState> _mapFamilyMemberUpdatedToState(String name, int position) async*{

    if(position != null){
      state.profile.familyMembers[position] = name;
    }else{
      state.profile.familyMembers.add(name);
    }

    Profile profile = Profile(state.profile.email, state.profile.familyMembers, displayName: state.profile.displayName, isEmailVerified: state.profile.isEmailVerified);

    Profile updProfile = await _profileRepository.updateProfile(profile);

    yield state.update(profile: updProfile);
  }

  Stream<ProfileState> _mapUpdateProfileStateToState(UpdateProfileState event) async* {
    yield ProfileState.success(profile: event.profile);
  }

  Stream<ProfileState> _mapGetProfileToState(GetProfile event) async*{
    yield ProfileState.loading();

    Profile profile = await _profileRepository.getCurrentProfile();

    if(profile == null){
      profile = await _profileRepository.addNewProfile();
    }

    yield ProfileState.success(profile: profile);
  }

}
