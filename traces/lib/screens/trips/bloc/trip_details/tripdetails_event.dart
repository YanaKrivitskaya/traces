part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsEvent {
  const TripDetailsEvent();

  List<Object> get props => [];
}

class NewTripMode extends TripDetailsEvent {}
