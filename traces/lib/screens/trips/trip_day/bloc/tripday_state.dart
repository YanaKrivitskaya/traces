part of 'tripday_bloc.dart';

@immutable
abstract class TripDayState {
  final TripDay? tripDay;

  TripDayState(this.tripDay);

  @override
  List<Object?> get props => [];
}

class TripDayInitial extends TripDayState {
  TripDayInitial(TripDay? tripDay) : super(tripDay);
}

class TripDayError extends TripDayState {
  final String error;

  TripDayError(TripDay? tripDay, this.error) : super(tripDay);

  @override
  List<Object?> get props => [tripDay, error];
}

class TripDaySuccess extends TripDayState {

  TripDaySuccess(TripDay tripDay) : super(tripDay);

  @override
  List<Object?> get props => [tripDay];
}
