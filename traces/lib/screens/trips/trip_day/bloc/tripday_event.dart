part of 'tripday_bloc.dart';

@immutable
abstract class TripDayEvent {
  List<Object?> get props => [];
}

class TripDayLoaded extends TripDayEvent {
  final TripDay tripDay;
 
  TripDayLoaded(this.tripDay);

  List<Object> get props => [tripDay];
}
