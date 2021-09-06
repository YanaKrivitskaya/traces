import 'package:meta/meta.dart';

import 'package:traces/screens/trips/model/trip_object.model.dart';

@immutable
class TripDay {
  final List<TripEvent> tripEvents;
  final int tripId;
  final DateTime date;
  final int dayNumber; 
  
  TripDay({
    required this.tripEvents,
    required this.tripId,
    required this.date,
    required this.dayNumber,
  });


  TripDay copyWith({
    List<TripEvent>? tripEvents,
    int? tripId,
    DateTime? date,
    int? dayNumber,
  }) {
    return TripDay(
      tripEvents: tripEvents ?? this.tripEvents,
      tripId: tripId ?? this.tripId,
      date: date ?? this.date,
      dayNumber: dayNumber ?? this.dayNumber,
    );
  }
}
