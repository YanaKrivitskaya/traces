part of 'tripmembers_bloc.dart';

abstract class TripMembersEvent extends Equatable {
  const TripMembersEvent();

  @override
  List<Object> get props => [];
}

class GetMembers extends TripMembersEvent {}

class MemberChecked extends TripMembersEvent{
  final String member;
  final bool checked;

  const MemberChecked(this.member, this.checked);

  @override
  List<Object> get props => [member, checked];
}