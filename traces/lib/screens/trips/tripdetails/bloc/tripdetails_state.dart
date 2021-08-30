part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsState extends Equatable{
  final Trip? trip;
  final List<GroupUser>? familyMembers;
  final int activeTab;

  const TripDetailsState(this.trip, this.familyMembers, this.activeTab);

  @override
  List<Object?> get props => [trip, familyMembers, activeTab];
}

class TripDetailsInitial extends TripDetailsState {
  TripDetailsInitial(int activeTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab);
}

class TripDetailsLoading extends TripDetailsState {
  TripDetailsLoading(int activeTab, {Trip? trip, List<GroupUser>? familyMembers}) 
    : super(trip, familyMembers, activeTab);
}

class TripDetailsDeleted extends TripDetailsState {
  TripDetailsDeleted(int activeTab, {Trip? trip, List<GroupUser>? familyMembers}) : super(trip, familyMembers, activeTab);
}

class TripDetailsSuccessState extends TripDetailsState{
  final Trip trip;
  final List<GroupUser> familyMembers;
  final int activeTab;

  TripDetailsSuccessState(this.trip, this.familyMembers, this.activeTab) 
    : super(trip, familyMembers, activeTab);

  @override
  List<Object> get props => [trip, familyMembers, activeTab];
}

class TripDetailsErrorState extends TripDetailsState{ 
  final String error;

  TripDetailsErrorState(this.error, int activeTab, {Trip? trip, List<GroupUser>? familyMembers}) : super(trip, familyMembers, activeTab);

  @override
  List<Object?> get props => [error, trip, familyMembers, activeTab];

}