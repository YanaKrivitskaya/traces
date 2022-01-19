part of 'ticketview_bloc.dart';

@immutable
abstract class TicketViewEvent {}

class GetTicketDetails extends TicketViewEvent {
  final int ticketId;

  GetTicketDetails(this.ticketId);

  List<Object> get props => [ticketId];
}
