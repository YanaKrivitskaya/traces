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

class UpdateTripDetailsSuccess extends TripDetailsEvent{
  final List<Member> members;
  final Trip trip;

  const UpdateTripDetailsSuccess(this.members, this.trip);

  @override
  List<Object> get props => [members, trip];
}

class DeleteTripClicked extends TripDetailsEvent{
  final String tripId;

  const DeleteTripClicked(this.tripId);

  @override
  List<Object> get props => [tripId];
}
