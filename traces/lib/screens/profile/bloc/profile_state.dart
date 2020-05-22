import 'package:meta/meta.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/profile.dart';

class ProfileState {
  final Profile profile;
  final List<Family> familyMembers;
  final bool isLoading;
  final bool isSuccess;
  final bool isFailure;
  final String errorMessage;

  const ProfileState({
    @required this.profile,
    @required this.familyMembers,
    @required this.isLoading,
    @required this.isSuccess,
    @required this.isFailure,
    this.errorMessage});

  factory ProfileState.empty(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isLoading: false,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.loading(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isLoading: true,
        isSuccess: false,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.success({Profile profile, List<Family> familyMembers}){
    return ProfileState(
        profile: profile,
        familyMembers: familyMembers,
        isLoading: false,
        isSuccess: true,
        isFailure: false,
        errorMessage: ""
    );
  }

  factory ProfileState.failure({Profile profile, List<Family> familyMembers, String error}){
    return ProfileState(
        profile: profile,
        familyMembers: familyMembers,
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: error
    );
  }

  ProfileState copyWith({
    final Profile profile,
    final List<Family> familyMembers,
    bool searchEnabled,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return ProfileState(
        profile: profile ?? this.profile,
        familyMembers: familyMembers ?? this.familyMembers,
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  ProfileState update({
    Profile profile,
    List<Family> familyMembers,
    bool isLoading,
    bool isSuccess,
    bool isFailure,
    String errorMessage
  }){
    return copyWith(
        profile: profile,
        familyMembers: familyMembers,
        isLoading: isLoading,
        isSuccess: isSuccess,
        isFailure: isFailure,
        errorMessage: errorMessage
    );
  }

}

