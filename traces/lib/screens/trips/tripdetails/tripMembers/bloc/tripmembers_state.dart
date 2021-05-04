part of 'tripmembers_bloc.dart';

@immutable
abstract class TripMembersState extends Equatable{
  const TripMembersState();

  @override
  List<Object> get props => [];
}

class InitialTripMembersState extends TripMembersState {}

class SuccessTripMembersState  extends TripMembersState {
  final List<String> members;

  SuccessTripMembersState(this.members);

  @override
  List<Object> get props => [members];
}