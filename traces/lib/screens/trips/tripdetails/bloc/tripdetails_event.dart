part of 'tripdetails_bloc.dart';

@immutable
abstract class TripDetailsEvent {
  const TripDetailsEvent();

  List<Object?> get props => [];
}

class GetTripDetails extends TripDetailsEvent {
  final int tripId;

  GetTripDetails(this.tripId);

  @override
  List<Object> get props => [tripId];
}

class UpdateTripDetailsSuccess extends TripDetailsEvent{
  final List<GroupUser> members;
  final Trip trip;

  const UpdateTripDetailsSuccess(this.members, this.trip);

  @override
  List<Object> get props => [members, trip];
}

class DeleteTripClicked extends TripDetailsEvent{
  final int tripId;

  const DeleteTripClicked(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateTripClicked extends TripDetailsEvent{
  final Trip updTrip;

  const UpdateTripClicked(this.updTrip);

  @override
  List<Object?> get props => [updTrip];
}

class DateRangeUpdated extends TripDetailsEvent {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeUpdated(this.startDate, this.endDate);

  List<Object> get props => [startDate, endDate];
}

class TabUpdated extends TripDetailsEvent{
  final int tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';
}

class UpdateExpenses extends TripDetailsEvent{
  final int tripId;

  const UpdateExpenses(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateBookings extends TripDetailsEvent{
  final int tripId;

  const UpdateBookings(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateTickets extends TripDetailsEvent{
  final int tripId;

  const UpdateTickets(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateNotes extends TripDetailsEvent{
  final int tripId;

  const UpdateNotes(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class UpdateActivities extends TripDetailsEvent{
  final int tripId;

  const UpdateActivities(this.tripId);

  @override
  List<Object?> get props => [tripId];
}

class GetImage extends TripDetailsEvent{
  final CroppedFile? image;

  const GetImage(this.image);

  @override
  List<Object?> get props => [image];
}

