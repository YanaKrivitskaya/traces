import 'package:meta/meta.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/shared/state_types.dart';

class ProfileState {
  final Profile profile;
  final bool isUsernameValid;
  final StateMode mode;
  final StateStatus status;
  final String errorMessage;

  const ProfileState({
    @required this.profile,
    @required this.isUsernameValid,
    @required this.mode,
    @required this.status,
    this.errorMessage});

  factory ProfileState.empty(){
    return ProfileState(
        profile: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Empty,
        errorMessage: ""
    );
  }

  factory ProfileState.loading(){
    return ProfileState(
        profile: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Loading,
        errorMessage: ""
    );
  }

  factory ProfileState.success({Profile profile}){
    return ProfileState(
        profile: profile,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Success,
        errorMessage: ""
    );
  }

  factory ProfileState.failure({Profile profile, String error}){
    return ProfileState(
        profile: profile,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  ProfileState copyWith({
    final Profile profile,
    bool isUsernameValid,
    StateMode mode,
    StateStatus stateStatus,
    String errorMessage
  }){
    return ProfileState(
        profile: profile ?? this.profile,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        mode: mode ?? this.mode,
        status: stateStatus ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  ProfileState update({
    Profile profile,
    bool isUsernameValid,
    StateMode mode,
    StateStatus state,
    String errorMessage
  }){
    return copyWith(
        profile: profile,
        isUsernameValid: isUsernameValid,
        mode: mode,
        stateStatus: state,
        errorMessage: errorMessage
    );
  }

}

