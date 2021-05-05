import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/model/profile.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {}

class ShowFamilyDialog extends ProfileEvent {}

class UpdateProfileState extends ProfileEvent {
  final List<Member> familyMembers;

  final Profile profile;

  const UpdateProfileState(this.familyMembers, this.profile);

  @override
  List<Object> get props => [familyMembers, profile];
}

class UsernameChanged extends ProfileEvent{
  final String username;

  const UsernameChanged({@required this.username});

  @override
  List<Object> get props => [username];
}

class FamilyUpdated extends ProfileEvent{
  final String id;
  final String name;

  const FamilyUpdated({@required this.id, @required this.name});

  @override
  List<Object> get props => [id, name];
}

class UsernameUpdated extends ProfileEvent{
  final String username;

  const UsernameUpdated({@required this.username});

  @override
  List<Object> get props => [username];
}

