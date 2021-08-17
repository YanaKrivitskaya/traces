part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsState extends Equatable{
  const TripDetailsState();

  @override
  List<Object?> get props => [];
}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsDeleted extends TripDetailsState {}

class TripDetailsSuccessState extends TripDetailsState{
  final Trip trip;
  final List<GroupUser> familyMembers;

  TripDetailsSuccessState(this.trip, this.familyMembers);

  @override
  List<Object> get props => [trip, familyMembers];

}

class TripDetailsErrorState extends TripDetailsState{
  final String error;

  TripDetailsErrorState(this.error);

  @override
  List<Object> get props => [error];

}