import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';

class TripDayArguments {
  TripDayArguments({ required this.day, required this.trip });
  final TripDay day;
  final Trip trip;      
}

class EventArguments {
  EventArguments({this.date, required this.trip });
  final DateTime? date;
  final Trip trip;      
}