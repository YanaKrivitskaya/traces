part of 'trip_list_bloc.dart';

@immutable
abstract class TripListEvent {
  List<Object?> get props => [];
}

class GetTripsList extends TripListEvent {
  final Note note;

  GetTripsList(this.note);

  List<Object?> get props => [note];
}

class TripUpdated extends TripListEvent {  
  final Trip trip;

  TripUpdated(this.trip);

  List<Object?> get props => [trip];
}

class TripSubmitted extends TripListEvent {
  final int noteId;
  final int tripId;

  TripSubmitted(this.noteId, this.tripId);

  List<Object?> get props => [noteId, tripId];
}
