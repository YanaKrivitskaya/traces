part of 'family_bloc.dart';

@immutable
abstract class FamilyEvent {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class NewMode extends FamilyEvent {}

class EditMode extends FamilyEvent {
  final Family familyMember;

  const EditMode({@required this.familyMember});

  @override
  List<Object> get props => [familyMember];
}

class UsernameFamilyChanged extends FamilyEvent{
  final String username;

  const UsernameFamilyChanged({@required this.username});

  @override
  List<Object> get props => [username];
}

class GenderUpdated extends FamilyEvent{
  final String gender;

  const GenderUpdated({@required this.gender});

  @override
  List<Object> get props => [gender];
}

class FamilyAdded extends FamilyEvent{
  final Family newMember;

  const FamilyAdded({@required this.newMember});

  @override
  List<Object> get props => [newMember];
}

class FamilyUpdated extends FamilyEvent{
  final Family updMember;

  const FamilyUpdated({@required this.updMember});

  @override
  List<Object> get props => [updMember];
}

