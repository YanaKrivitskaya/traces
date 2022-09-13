part of 'current_trip_bloc.dart';

@immutable
abstract class CurrentTripState {}

class CurrentTripInitial extends CurrentTripState {
  CurrentTripInitial():super();
}

class CurrentTripLoadingState extends CurrentTripState {
  CurrentTripLoadingState():super();
}

class CurrentTripSuccessState extends CurrentTripState {  
  final Trip? trip;
  final TripDay? tripDay;
  CurrentTripSuccessState(this.trip, this.tripDay):super();

  @override
  List<Object?> get props => [trip, tripDay];
}
