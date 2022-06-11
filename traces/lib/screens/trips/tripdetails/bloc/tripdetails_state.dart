part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsState{
  final Trip? trip;
  final List<GroupUser>? familyMembers;
  final int activeTripTab;
  final int activeActivityTab;

  const TripDetailsState(this.trip, this.familyMembers, this.activeTripTab, this.activeActivityTab);

  @override
  List<Object?> get props => [trip, familyMembers, activeTripTab, activeActivityTab];
}

class TripDetailsInitial extends TripDetailsState {
  TripDetailsInitial(int activeTab, int activeActivityTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab);
}

class TripDetailsLoading extends TripDetailsState {
  TripDetailsLoading(int activeTab, int activeActivityTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab);
}

class TripDetailsDeleted extends TripDetailsState {
  TripDetailsDeleted(int activeTab, int activeActivityTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab);
}

class TripDetailsUpdated extends TripDetailsState {
  TripDetailsUpdated(int activeTab, int activeActivityTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab);
}

class TripDetailsSuccessState extends TripDetailsState{

  TripDetailsSuccessState(Trip trip, List<GroupUser> familyMembers, int activeTab, int activeActivityTab) 
    : super(trip, familyMembers, activeTab, activeActivityTab);
}

class TripDetailsErrorState extends TripDetailsState{ 
  final String error;

  TripDetailsErrorState(this.error, int activeTab, int activeActivityTab, {Trip? trip, List<GroupUser>? familyMembers}) 
  : super(trip, familyMembers, activeTab, activeActivityTab);

  @override
  List<Object?> get props => [error, trip, familyMembers, activeTripTab, activeActivityTab];

}