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
  CurrentTripSuccessState(this.trip):super();

  @override
  List<Object?> get props => [trip];
}
