part of 'tripmembers_bloc.dart';

@immutable
abstract class TripMembersState{
  final List<GroupUser> members;
  final List<int>? selectedMembers;

  const TripMembersState(this.members, this.selectedMembers);

  @override
  List<Object?> get props => [members, selectedMembers];
}

class LoadingTripMembersState extends TripMembersState{
  LoadingTripMembersState() : super(List.empty(), List.empty());
}

class SuccessTripMembersState  extends TripMembersState {  
  SuccessTripMembersState(List<GroupUser> members, List<int>? selectedMembers) : super(members, selectedMembers);  
}

class SubmittedTripMembersState  extends TripMembersState {  
  SubmittedTripMembersState(List<GroupUser> members, List<int>? selectedMembers) : super(members, selectedMembers);  
}