part of 'ticketedit_bloc.dart';

@immutable
abstract class TicketEditEvent {
  List<Object?> get props => [];
}

class NewTicketMode extends TicketEditEvent {
  final DateTime? date;
 
  NewTicketMode(this.date);

  List<Object?> get props => [date];
}

class EditTicketMode extends TicketEditEvent {
  final Ticket ticket;
 
  EditTicketMode(this.ticket);

  List<Object?> get props => [ticket];
}

class DepartureDateUpdated extends TicketEditEvent {
  final DateTime departureDate;
 
  DepartureDateUpdated(this.departureDate);

  List<Object> get props => [departureDate];
}

class ArrivalDateUpdated extends TicketEditEvent {
  final DateTime arrivalDate;
 
  ArrivalDateUpdated(this.arrivalDate);

  List<Object> get props => [arrivalDate];
}

class ExpenseUpdated extends TicketEditEvent {
  final Expense? expense;  

  ExpenseUpdated(this.expense);

  List<Object?> get props => [expense];
}

class TicketSubmitted extends TicketEditEvent {
  final Ticket? ticket;
  final Expense? expense;
  final int tripId;
  final int? userId;
  
  TicketSubmitted(this.ticket, this.expense, this.tripId, this.userId);

  List<Object?> get props => [ticket, expense, tripId, userId];
}
