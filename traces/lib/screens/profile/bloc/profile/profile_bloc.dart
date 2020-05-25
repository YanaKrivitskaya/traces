import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/loginSignup/validator.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'bloc.dart';
import 'package:meta/meta.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription _profileSubscription;

  ProfileBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository;

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
  }

  Stream<ProfileState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isUsernameValid: LoginSignupValidator.isValidUsername(username)
    );
  }

  Stream<ProfileState> _mapUsernameUpdatedToState(String username) async*{

    await _profileRepository.updateUsername(username);

    Profile profile = Profile(state.profile.email, displayName: username, isEmailVerified: state.profile.isEmailVerified);

    Profile updProfile = await _profileRepository.updateProfile(profile);

    yield state.update(profile: updProfile);

    /*yield state.update(
        isUsernameValid: LoginSignupValidator.isValidUsername(username)
    );*/
  }

  Stream<ProfileState> _mapUpdateProfileStateToState(UpdateProfileState event) async* {
    yield ProfileState.success(profile: event.profile, familyMembers: event.familyMembers);
  }

  Stream<ProfileState> _mapGetProfileToState(GetProfile event) async*{
    yield ProfileState.loading();

    Profile profile = await _profileRepository.getCurrentProfile();

    if(profile == null){
      profile = await _profileRepository.addNewProfile();
    }

    _profileSubscription?.cancel();

    _profileSubscription = _profileRepository.familyMembers().listen(
          (familyMembers) => add(UpdateProfileState(familyMembers, profile)),
    );
  }

}
