part of 'trip_list_bloc.dart';

@immutable
abstract class TripListState {
  final List<Trip>? trips;
  final Trip? selectedTrip;
  final Trip? currentTrip;

  TripListState(this.trips, this.selectedTrip, this.currentTrip);

  @override
  List<Object?> get props => [trips, selectedTrip, currentTrip];
}

class TripListInitial extends TripListState {
  TripListInitial() : super(null, null, null);
}

class TripListLoading extends TripListState {
  TripListLoading(List<Trip>? trips, Trip? selectedTrip, Trip? currentTrip) : super(trips, selectedTrip, currentTrip);
}

class TripListSuccess extends TripListState { 

  TripListSuccess(List<Trip>? trips, Trip? selectedTrip, Trip? currentTrip):super(trips, selectedTrip, currentTrip);
}

class TripListSubmitted extends TripListState {
  TripListSubmitted(List<Trip>? trips, Trip? selectedTrip, Trip? currentTrip):super(trips, selectedTrip, currentTrip);
}

class TripListFailure extends TripListState {
  final String error;
 
  TripListFailure(List<Trip>? trips, Trip? selectedTrip, Trip? currentTrip, this.error):super(trips, selectedTrip, currentTrip);

  @override
  List<Object?> get props => [trips, selectedTrip, error, currentTrip];
}

