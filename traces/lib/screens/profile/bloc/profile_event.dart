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