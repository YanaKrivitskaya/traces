part of 'ticketview_bloc.dart';

abstract class TicketViewState {
  Ticket? ticket;

  TicketViewState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketViewInitial extends TicketViewState {
  TicketViewInitial(Ticket? ticket) : super(ticket);
}

class TicketViewLoading extends TicketViewState {
  TicketViewLoading(Ticket? ticket) : super(ticket);
}

class TicketViewSuccess extends TicketViewState {

  TicketViewSuccess(Ticket? ticket) : super(ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketViewError extends TicketViewState {
  final String error;

  TicketViewError(Ticket? ticket, this.error) : super(ticket);

  @override
  List<Object?> get props => [ticket, error];
}
