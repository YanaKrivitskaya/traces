import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/profile.dart';


abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {}

class UpdateProfileState extends ProfileEvent {
  final List<Family> familyMembers;

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

class UsernameUpdated extends ProfileEvent{
  final String username;

  const UsernameUpdated({@required this.username});

  @override
  List<Object> get props => [username];
}

