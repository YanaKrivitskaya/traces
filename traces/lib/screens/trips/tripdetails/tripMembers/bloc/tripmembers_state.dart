part of 'tripmembers_bloc.dart';

@immutable
abstract class TripMembersState{
  final List<Member> members;
  final List<String?> selectedMembers;

  const TripMembersState(this.members, this.selectedMembers);

  @override
  List<Object> get props => [members, selectedMembers];
}

class LoadingTripMembersState extends TripMembersState{
  LoadingTripMembersState() : super(List.empty(), List.empty());
}

class SuccessTripMembersState  extends TripMembersState {  
  SuccessTripMembersState(List<Member> members, List<String?> selectedMembers) : super(members, selectedMembers);  
}

class SubmittedTripMembersState  extends TripMembersState {  
  SubmittedTripMembersState(List<Member> members, List<String?> selectedMembers) : super(members, selectedMembers);  
}