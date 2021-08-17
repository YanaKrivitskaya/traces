part of 'tripmembers_bloc.dart';

abstract class TripMembersEvent extends Equatable {
  const TripMembersEvent();

  @override
  List<Object?> get props => [];
}

class GetMembers extends TripMembersEvent {
  final int? tripId;

  const GetMembers(this.tripId);
  
  @override
  List<Object?> get props => [tripId]; 
}

class UpdateTripMembersSuccess extends TripMembersEvent{
  final List<GroupUser> members;
  final List<GroupUser?> selectedMembers;

  const UpdateTripMembersSuccess(this.members, this.selectedMembers);

  @override
  List<Object> get props => [members, selectedMembers];
}

class MemberChecked extends TripMembersEvent{
  final int? memberId;
  final bool? checked;

  const MemberChecked(this.memberId, this.checked);

  @override
  List<Object?> get props => [memberId, checked];
}

class SubmitTripMembers extends TripMembersEvent{
  final int tripId;
  final List<int>? selectedMembers;

  const SubmitTripMembers(this.tripId, this.selectedMembers);

  @override
  List<Object?> get props => [tripId, selectedMembers];
}