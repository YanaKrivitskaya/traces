part of 'tripmembers_bloc.dart';

abstract class TripMembersEvent extends Equatable {
  const TripMembersEvent();

  @override
  List<Object?> get props => [];
}

class GetMembers extends TripMembersEvent {
  final String? tripId;

  const GetMembers(this.tripId);
  
  @override
  List<Object?> get props => [tripId]; 
}

class UpdateTripMembersSuccess extends TripMembersEvent{
  final List<Member> members;
  final List<String?> selectedMembers;

  const UpdateTripMembersSuccess(this.members, this.selectedMembers);

  @override
  List<Object> get props => [members, selectedMembers];
}

class MemberChecked extends TripMembersEvent{
  final String? memberId;
  final bool? checked;

  const MemberChecked(this.memberId, this.checked);

  @override
  List<Object?> get props => [memberId, checked];
}

class SubmitTripMembers extends TripMembersEvent{
  final String? tripId;
  final List<String?> selectedMembers;

  const SubmitTripMembers(this.tripId, this.selectedMembers);

  @override
  List<Object?> get props => [tripId, selectedMembers];
}