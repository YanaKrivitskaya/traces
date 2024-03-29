part of 'bookingcreate_bloc.dart';

@immutable
abstract class BookingCreateEvent {
  List<Object?> get props => [];
}

class NewBookingMode extends BookingCreateEvent {
  final DateTime? date;
 
  NewBookingMode(this.date);

  List<Object?> get props => [date];
}

class EditBookingMode extends BookingCreateEvent {
  final Booking booking;
 
  EditBookingMode(this.booking);

  List<Object?> get props => [booking];
}

class DateRangeUpdated extends BookingCreateEvent {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeUpdated(this.startDate, this.endDate);

  List<Object> get props => [startDate, endDate];
}

class ExpenseUpdated extends BookingCreateEvent {
  final Expense? expense;  

  ExpenseUpdated(this.expense);

  List<Object?> get props => [expense];
}

class BookingSubmitted extends BookingCreateEvent {
  final Booking? booking;
  final Expense? expense;
  final int tripId;  
  
  BookingSubmitted(this.booking, this.expense, this.tripId);

  List<Object?> get props => [booking, expense, tripId,];
}
