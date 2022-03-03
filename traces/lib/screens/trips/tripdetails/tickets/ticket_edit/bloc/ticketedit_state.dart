part of 'ticketedit_bloc.dart';

abstract class TicketEditState {
  Ticket? ticket;

  TicketEditState(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

class TicketCreateInitial extends TicketEditState {
  TicketCreateInitial(Ticket? ticket) : super(ticket);
}

class TicketCreateEdit extends TicketEditState {
  final bool loading;

  TicketCreateEdit(Ticket? ticket, this.loading) : super(ticket);

  @override
  List<Object?> get props => [ticket, loading];
}

class TicketCreateError extends TicketEditState {
  final String error;

  TicketCreateError(Ticket? ticket, this.error) : super(ticket);

  @override
  List<Object?> get props => [ticket, error];
}

class TicketCreateSuccess extends TicketEditState {

  TicketCreateSuccess(Ticket? ticket) : super(ticket);

  @override
  List<Object?> get props => [ticket];
}
