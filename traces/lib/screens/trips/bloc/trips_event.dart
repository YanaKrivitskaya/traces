part of 'trips_bloc.dart';

@immutable
abstract class TripsEvent extends Equatable {
  const TripsEvent();

  @override
  List<Object> get props => [];
}

class GetAllTrips extends TripsEvent{}

class UpdateTripsList extends TripsEvent{
  final List<Trip> trips;

  const UpdateTripsList(this.trips);

  @override
  List<Object> get props => [trips];
}

class TabUpdated extends TripsEvent{
  final int tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}



