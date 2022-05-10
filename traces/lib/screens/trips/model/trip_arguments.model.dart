import 'package:traces/screens/trips/model/activity.model.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';
import 'package:traces/screens/trips/model/trip_day.model.dart';

class TripDayArguments {
  TripDayArguments({ required this.day, required this.trip });
  final TripDay day;
  final Trip trip;      
}

class TicketViewArguments {
  TicketViewArguments({ required this.ticketId, required this.trip });
  final int ticketId;
  final Trip trip;      
}

class ActivityViewArguments {
  ActivityViewArguments({ required this.activityId, required this.trip });
  final int activityId;
  final Trip trip;      
}

class ActivityEditArguments {
  ActivityEditArguments({ required this.activity, required this.trip });
  final Activity activity;
  final Trip trip;      
}

class BookingViewArguments {
  BookingViewArguments({ required this.bookingId, required this.trip });
  final int bookingId;
  final Trip trip;      
}

class BookingEditArguments {
  BookingEditArguments({ required this.booking, required this.trip });
  final Booking booking;
  final Trip trip;      
}

class ExpenseViewArguments {
  ExpenseViewArguments({ required this.expenseId, required this.trip });
  final int expenseId;  
  final Trip trip;      
}

class ExpenseEditArguments {
  ExpenseEditArguments({ required this.expense, required this.trip });
  final Expense expense;  
  final Trip trip; 
}

class TicketEditArguments {
  TicketEditArguments({ required this.ticket, required this.trip });
  final Ticket ticket;
  final Trip trip;      
}

class EventArguments {
  EventArguments({this.date, required this.trip });
  final DateTime? date;
  final Trip trip;      
}