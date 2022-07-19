part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsState{
  final Trip? trip;
  final List<GroupUser>? familyMembers;
  final int activeTripTab;
  final int activeActivityTab;
  final int activeExpenseTab;

  const TripDetailsState(this.trip, this.familyMembers, this.activeTripTab, this.activeActivityTab, this.activeExpenseTab);

  @override
  List<Object?> get props => [trip, familyMembers, activeTripTab, activeActivityTab, activeExpenseTab];
}

class TripDetailsInitial extends TripDetailsState {
  TripDetailsInitial(int activeTab, int activeActivityTab, int activeExpenseTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);
}

class TripDetailsLoading extends TripDetailsState {
  TripDetailsLoading(int activeTab, int activeActivityTab, int activeExpenseTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);
}

class TripDetailsDeleted extends TripDetailsState {
  TripDetailsDeleted(int activeTab, int activeActivityTab, int activeExpenseTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);
}

class TripDetailsUpdated extends TripDetailsState {
  TripDetailsUpdated(int activeTab, int activeActivityTab, int activeExpenseTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);
}

class TripDetailsSuccessState extends TripDetailsState{

  TripDetailsSuccessState(Trip trip, List<GroupUser> familyMembers, int activeTab, int activeActivityTab, int activeExpenseTab) 
    : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);
}

class TripDetailsErrorState extends TripDetailsState{ 
  final String error;

  TripDetailsErrorState(this.error, int activeTab, int activeActivityTab, int activeExpenseTab, {Trip? trip, List<GroupUser>? familyMembers}) 
  : super(trip, familyMembers, activeTab, activeActivityTab, activeExpenseTab);

  @override
  List<Object?> get props => [error, trip, familyMembers, activeTripTab, activeActivityTab, activeExpenseTab];

}