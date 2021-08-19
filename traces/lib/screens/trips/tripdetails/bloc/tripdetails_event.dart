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

class TabUpdated extends TripDetailsEvent{
  final int tab;

  const TabUpdated(this.tab);

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'UpdateTab { tab: $tab }';

}

