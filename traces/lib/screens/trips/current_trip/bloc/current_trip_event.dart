part of 'current_trip_bloc.dart';


@immutable
abstract class CurrentTripEvent {
  const CurrentTripEvent();

  List<Object?> get props => [];
}

class GetCurrentTrip extends CurrentTripEvent {}

