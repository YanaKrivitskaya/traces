part of 'activitycreate_bloc.dart';

@immutable
abstract class ActivityCreateEvent {
  List<Object?> get props => [];
}

class NewActivityMode extends ActivityCreateEvent {}

class DateUpdated extends ActivityCreateEvent {
  final DateTime date;
 
  DateUpdated(this.date);

  List<Object> get props => [date];
}

class PlannedUpdated extends ActivityCreateEvent {
  final bool isPlanned;
 
  PlannedUpdated(this.isPlanned);

  List<Object> get props => [isPlanned];
}

class CompletedUpdated extends ActivityCreateEvent {
  final bool isCompleted;
 
  CompletedUpdated(this.isCompleted);

  List<Object> get props => [isCompleted];
}

class ActivitySubmitted extends ActivityCreateEvent {
  final Activity? activity;
  final Expense? expense;
  final int tripId;
  
  ActivitySubmitted(this.activity, this.expense, this.tripId);

  List<Object?> get props => [activity, expense, tripId];
}
