import 'package:meta/meta.dart';

enum TripEventType{
  Booking, 
  Ticket,
  Activity
}

@immutable
class TripEvent {
  final TripEventType type;
  final int id;
  final DateTime? startDate;
  final DateTime? endDate; 
  final dynamic event;

  TripEvent({
    required this.type,
    required this.id,
    required this.event,
    this.startDate,
    this.endDate
  });
  

  TripEvent copyWith({
    TripEventType? type,
    int? id,
    dynamic event,
    DateTime? startDate,
    DateTime? endDate
  }) {
    return TripEvent(
      type: type ?? this.type,
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      event: event ?? this.event
    );
  }
}



