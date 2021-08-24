part of 'ticketcreate_bloc.dart';

@immutable
abstract class TicketCreateEvent {
  List<Object?> get props => [];
}

class NewTicketMode extends TicketCreateEvent {}

class DepartureDateUpdated extends TicketCreateEvent {
  final DateTime departureDate;
 
  DepartureDateUpdated(this.departureDate);

  List<Object> get props => [departureDate];
}

class ArrivalDateUpdated extends TicketCreateEvent {
  final DateTime arrivalDate;
 
  ArrivalDateUpdated(this.arrivalDate);

  List<Object> get props => [arrivalDate];
}

class TicketSubmitted extends TicketCreateEvent {
  final Ticket? ticket;
  final Expense? expense;
  final int tripId;
  final int? userId;
  
  TicketSubmitted(this.ticket, this.expense, this.tripId, this.userId);

  List<Object?> get props => [ticket, expense, tripId, userId];
}