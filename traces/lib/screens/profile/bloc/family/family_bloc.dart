import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/loginSignup/validator.dart';
import 'package:traces/screens/profile/bloc/profile/bloc.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  final ProfileRepository _profileRepository;
  StreamSubscription _profileSubscription;

  FamilyBloc({@required ProfileRepository profileRepository})
      : assert(profileRepository != null),
        _profileRepository = profileRepository;

  @override
  FamilyState get initialState => FamilyState.loading();

  @override
  Stream<FamilyState> mapEventToState(FamilyEvent event) async* {
    if (event is NewMode) {
      yield* _mapNewModeToState();
    } else if (event is UsernameFamilyChanged) {
      yield* _mapUsernameChangedToState(event.username);
    }else if (event is GenderUpdated) {
      yield* _mapGenderUpdateToState(event.gender);
    }else if (event is FamilyAdded) {
      yield* _mapFamilyAddedToState(event);
    }else if (event is EditMode) {
      yield* _mapEditModeToState(event);
    }else if (event is FamilyUpdated) {
      yield* _mapFamilyUpdatedToState(event);
    }
  }

  Stream<FamilyState> _mapNewModeToState() async*{
    Family newMember = Family('', gender: 'Male');
    yield FamilyState.success(
        family: newMember,
        selectedGender: 'Male',
        isNewMode: true
    );
  }

  Stream<FamilyState> _mapEditModeToState(EditMode event) async*{
    yield FamilyState.success(
        family: event.familyMember,
        selectedGender: event.familyMember.gender,
        isNewMode: false,
        isEditing: false
    );
  }

  Stream<FamilyState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isUsernameValid: LoginSignupValidator.isValidUsername(username),
        isEditing: true
    );
  }

  Stream<FamilyState> _mapGenderUpdateToState(String gender) async*{
    yield state.update(
        selectedGender: gender
    );
  }

  Stream<FamilyState> _mapFamilyAddedToState(FamilyAdded event) async*{
    yield state.update(isLoading: true);

    await _profileRepository.addNewFamilyMember(event.newMember);

    yield state.update(isLoading: false);
  }

  Stream<FamilyState> _mapFamilyUpdatedToState(FamilyUpdated event) async*{
    yield state.update(isLoading: true);

    await _profileRepository.updateFamilyMember(event.updMember);

    yield state.update(isLoading: false);
  }
}
