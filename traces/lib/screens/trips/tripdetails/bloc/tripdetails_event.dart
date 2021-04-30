part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsEvent {
  const TripDetailsEvent();

  List<Object> get props => [];
}

class GetTripDetails extends TripDetailsEvent {
  final String tripId;

  GetTripDetails(this.tripId);

  @override
  List<Object> get props => [tripId];
}
