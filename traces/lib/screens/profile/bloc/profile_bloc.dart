import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import './bloc.dart';
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
    }
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
