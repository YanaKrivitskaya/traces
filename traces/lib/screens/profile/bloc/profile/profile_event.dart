import 'package:equatable/equatable.dart';

import '../../model/group_model.dart';
import '../../model/group_user_model.dart';
import '../../model/profile_model.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfile extends ProfileEvent {}

class ShowFamilyDialog extends ProfileEvent {}

class UpdateProfileState extends ProfileEvent {
  final List<GroupUser> familyMembers;

  final Profile profile;

  const UpdateProfileState(this.familyMembers, this.profile);

  @override
  List<Object> get props => [familyMembers, profile];
}

class UsernameChanged extends ProfileEvent{
  final String username;

  const UsernameChanged({required this.username});

  @override
  List<Object> get props => [username];
}

class FamilyUpdated extends ProfileEvent{
  final int? userId;
  final String name;
  final int groupId;

  const FamilyUpdated({required this.userId, required this.name, required this.groupId});

  @override
  List<Object?> get props => [userId, name, groupId];
}

class UsernameUpdated extends ProfileEvent{
  final int userId;
  final String username;

  const UsernameUpdated({required this.username, required this.userId});

  @override
  List<Object> get props => [username, userId];
}

class UserRemovedFromGroup extends ProfileEvent{
  final GroupUser user;
  final Group group;

  const UserRemovedFromGroup({required this.user, required this.group});

  @override
  List<Object> get props => [user, group];
}

