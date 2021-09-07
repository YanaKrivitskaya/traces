import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';

import 'package:traces/screens/trips/model/trip_object.model.dart';
import '../../../widgets/widgets.dart';

@immutable
class TripDay {
  final List<TripEvent> tripEvents;
  final int tripId;
  final DateTime date;
   
  TripDay({
    required this.tripEvents,
    required this.tripId,
    required this.date
  });


  TripDay copyWith({
    List<TripEvent>? tripEvents,
    int? tripId,
    DateTime? date
  }) {
    return TripDay(
      tripEvents: tripEvents ?? this.tripEvents,
      tripId: tripId ?? this.tripId,
      date: date ?? this.date
    );
  }

  factory TripDay.fromMap(Map<String, dynamic> map, DateTime date) {
    List<TripEvent> tripEvents = [];
    
    var activities =  map['activities'] != null ? 
      List<Activity>.from(map['activities']?.map((x) => Activity.fromMap(x))) : null;
    var expenses =  map['expenses'] != null ? 
      List<Expense>.from(map['expenses']?.map((x) => Expense.fromMap(x))) : null;
    var tickets =  map['tickets'] != null ? 
      List<Ticket>.from(map['tickets']?.map((x) => Ticket.fromMap(x))) : null;
    var bookings =  map['bookings'] != null ? 
      List<Booking>.from(map['bookings']?.map((x) => Booking.fromMap(x))) : null;

    bookings?.forEach((booking) {     
      var objectDate = new DateTime.utc(date.year, date.month, date.day, 23, 59);
      if(booking.entryDate!.isSameDate(date)) objectDate = booking.entryDate!;
      if(booking.exitDate!.isSameDate(date)) objectDate = booking.exitDate!;

      tripEvents.add(new TripEvent(
        type: TripEventType.Booking,
        id: booking.id!,
        startDate: objectDate,
        event: booking
      ));
    });

    activities?.forEach((activity) {
      tripEvents.add(new TripEvent(
        type: TripEventType.Activity,
        id: activity.id!,
        startDate: activity.date!,
        event: activity
      ));
    });

    tickets?.forEach((ticket) {
      var startDate;
      var endDate;
      if(ticket.arrivalDatetime!.isSameDate(date)) endDate = ticket.arrivalDatetime!;
      if(ticket.departureDatetime!.isSameDate(date)) startDate = ticket.departureDatetime!;

      tripEvents.add(new TripEvent(
        type: TripEventType.Ticket,
        id: ticket.id!,
        startDate: startDate,
        endDate: endDate,        
        event: ticket
      ));
    });

    return TripDay(
      tripEvents: tripEvents,
      tripId: int.parse(map['tripId']),
      date: date,
    );
  }
}
