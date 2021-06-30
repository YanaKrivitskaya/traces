import '../../../../utils/misc/state_types.dart';
import '../../model/group_user_model.dart';
import '../../model/profile_model.dart';

class ProfileState {
  final Profile? profile;
  final List<GroupUser>? familyMembers;
  final bool isUsernameValid;
  final StateMode mode;
  final StateStatus status;
  final String? errorMessage;

  const ProfileState({
    required this.profile,
    required this.familyMembers,
    required this.isUsernameValid,
    required this.mode,
    required this.status,
    this.errorMessage});

  factory ProfileState.empty(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Empty,
        errorMessage: null
    );
  }

  factory ProfileState.loading(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Loading,
        errorMessage: null
    );
  }

  factory ProfileState.success({Profile? profile, List<GroupUser>? members}){
    return ProfileState(
        profile: profile,
        familyMembers: members,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Success,
        errorMessage: null
    );
  }

  factory ProfileState.failure({Profile? profile, List<GroupUser>? members, String? error}){
    return ProfileState(
        profile: profile,
        familyMembers: members,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Error,
        errorMessage: error
    );
  }

  ProfileState copyWith({
    final Profile? profile,
    final List<GroupUser>? members,
    bool? isUsernameValid,
    StateMode? mode,
    StateStatus? stateStatus,
    String? errorMessage
  }){
    return ProfileState(
        profile: profile ?? this.profile,
        familyMembers: members ?? this.familyMembers,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        mode: mode ?? this.mode,
        status: stateStatus ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  ProfileState update({
    Profile? profile,
    List<GroupUser>? members,
    bool? isUsernameValid,
    StateMode? mode,
    StateStatus? state,
    String? errorMessage
  }){
    return copyWith(
        profile: profile,
        members: members,
        isUsernameValid: isUsernameValid,
        mode: mode,
        stateStatus: state,
        errorMessage: errorMessage
    );
  }

}

