import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/profile.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {}

class UpdateProfileState extends ProfileEvent {
  final List<String> familyMembers;

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
  final String name;
  final int position;

  const FamilyUpdated({@required this.name, @required this.position});

  @override
  List<Object> get props => [name, position];
}

class UsernameUpdated extends ProfileEvent{
  final String username;

  const UsernameUpdated({@required this.username});

  @override
  List<Object> get props => [username];
}

