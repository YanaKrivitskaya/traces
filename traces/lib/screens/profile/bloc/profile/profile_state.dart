import 'package:traces/utils/api/customException.dart';

import '../../../../utils/misc/state_types.dart';
import '../../model/group_user_model.dart';
import '../../model/profile_model.dart';

class ProfileState {
  final Profile? profile;
  final List<GroupUser>? familyMembers;
  final bool isUsernameValid;
  final StateMode mode;
  final StateStatus status;
  final CustomException? exception;

  const ProfileState({
    required this.profile,
    required this.familyMembers,
    required this.isUsernameValid,
    required this.mode,
    required this.status,
    this.exception});

  factory ProfileState.empty(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Empty,
        exception: null
    );
  }

  factory ProfileState.loading(){
    return ProfileState(
        profile: null,
        familyMembers: null,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Loading,
        exception: null
    );
  }

  factory ProfileState.success({Profile? profile, List<GroupUser>? members}){
    return ProfileState(
        profile: profile,
        familyMembers: members,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Success,
        exception: null
    );
  }

  factory ProfileState.failure({Profile? profile, List<GroupUser>? members, CustomException? exception}){
    return ProfileState(
        profile: profile,
        familyMembers: members,
        isUsernameValid: true,
        mode: StateMode.View,
        status: StateStatus.Error,
        exception: exception
    );
  }

  ProfileState copyWith({
    final Profile? profile,
    final List<GroupUser>? members,
    bool? isUsernameValid,
    StateMode? mode,
    StateStatus? stateStatus,
    CustomException? exception
  }){
    return ProfileState(
        profile: profile ?? this.profile,
        familyMembers: members ?? this.familyMembers,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        mode: mode ?? this.mode,
        status: stateStatus ?? this.status,
        exception: exception ?? this.exception
    );
  }

  ProfileState update({
    Profile? profile,
    List<GroupUser>? members,
    bool? isUsernameValid,
    StateMode? mode,
    StateStatus? state,
    CustomException? exception
  }){
    return copyWith(
        profile: profile,
        members: members,
        isUsernameValid: isUsernameValid,
        mode: mode,
        stateStatus: state,
        exception: exception
    );
  }

}

