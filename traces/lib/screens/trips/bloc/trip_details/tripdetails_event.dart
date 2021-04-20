part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsEvent {
  const TripDetailsEvent();

  List<Object> get props => [];
}

class NewTripMode extends TripDetailsEvent {}

class DateRangeUpdated extends TripDetailsEvent {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeUpdated(this.startDate, this.endDate);

  List<Object> get props => [startDate, endDate];
}

class StartPlanningSubmitted extends TripDetailsEvent {
  final Trip trip;
  
  StartPlanningSubmitted(this.trip);

  List<Object> get props => [trip];
}
