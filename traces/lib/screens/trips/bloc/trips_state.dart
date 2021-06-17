part of 'trips_bloc.dart';

@immutable
abstract class TripsState extends Equatable{

  const TripsState();

  @override
  List<Object> get props => [];
}

class TripsInitial extends TripsState {}

class TripsSuccessState extends TripsState {
  final List<Trip> allTrips;
  
  const TripsSuccessState(this.allTrips);

  @override
  List<Object> get props => [allTrips];
}

