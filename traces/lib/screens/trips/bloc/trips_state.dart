part of 'trips_bloc.dart';

@immutable
abstract class TripsState{
  final List<Trip>? allTrips;
  final int activeTab;

  const TripsState(this.allTrips, this.activeTab);

  @override
  List<Object?> get props => [this.allTrips, this.activeTab];
}

class TripsInitial extends TripsState {
  TripsInitial(List<Trip>? allTrips, int activeTab):super(allTrips, activeTab);
}

class TripsLoadingState extends TripsState {
  TripsLoadingState(List<Trip>? allTrips, int activeTab):super(allTrips, activeTab);
}

class TripsSuccessState extends TripsState {  
  const TripsSuccessState(List<Trip>? allTrips, int activeTab):super(allTrips, activeTab);

  @override
  List<Object?> get props => [allTrips, activeTab];
}

