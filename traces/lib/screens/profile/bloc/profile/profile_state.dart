import 'package:meta/meta.dart';
import 'package:traces/screens/profile/model/profile.dart';

class ProfileState {
  final Profile profile;
  final bool isUsernameValid;
  final bool isEditing;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const ProfileState({
    @required this.profile,
    @required this.isUsernameValid,
    @required this.isEditing,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory ProfileState.empty(){
    return ProfileState(
        profile: null,
        isUsernameValid: true,
        isEditing: false,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.loading(){
    return ProfileState(
        profile: null,
        isUsernameValid: true,
        isEditing: false,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.success({Profile profile}){
    return ProfileState(
        profile: profile,
        isUsernameValid: true,
        isEditing: false,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.failure({Profile profile, String error}){
    return ProfileState(
        profile: profile,
        isUsernameValid: true,
        isEditing: false,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: error
    );
  }

  ProfileState copyWith({
    final Profile profile,
    bool isUsernameValid,
    bool isEditing,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return ProfileState(
        profile: profile ?? this.profile,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        isEditing: isEditing ?? this.isEditing,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  ProfileState update({
    Profile profile,
    bool isUsernameValid,
    bool isEditing,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        profile: profile,
        isUsernameValid: isUsernameValid,
        isEditing: isEditing,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }

}
