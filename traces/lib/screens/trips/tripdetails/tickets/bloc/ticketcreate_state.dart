part of 'ticketcreate_bloc.dart';

abstract class TicketCreateState {
  Ticket? ticket;

  TicketCreateState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketCreateInitial extends TicketCreateState {
  TicketCreateInitial(Ticket? ticket) : super(ticket);
}

class TicketCreateEdit extends TicketCreateState {
  final bool loading;

  TicketCreateEdit(Ticket? ticket, this.loading) : super(ticket);

  @override
  List<Object?> get props => [ticket, loading];
}

class TicketCreateError extends TicketCreateState {
  final String error;

  TicketCreateError(Ticket? ticket, this.error) : super(ticket);

  @override
  List<Object?> get props => [ticket, error];
}

class TicketCreateSuccess extends TicketCreateState {

  TicketCreateSuccess(Ticket? ticket) : super(ticket);

  @override
  List<Object?> get props => [ticket];
}
