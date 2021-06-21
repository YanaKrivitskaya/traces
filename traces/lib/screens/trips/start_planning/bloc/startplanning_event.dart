part of 'startplanning_bloc.dart';

@immutable
abstract class StartPlanningEvent {
  const StartPlanningEvent();

  List<Object?> get props => [];
}

class NewTripMode extends StartPlanningEvent {}

class DateRangeUpdated extends StartPlanningEvent {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeUpdated(this.startDate, this.endDate);

  List<Object> get props => [startDate, endDate];
}

class StartPlanningSubmitted extends StartPlanningEvent {
  final Trip? trip;
  
  StartPlanningSubmitted(this.trip);

  List<Object?> get props => [trip];
}
