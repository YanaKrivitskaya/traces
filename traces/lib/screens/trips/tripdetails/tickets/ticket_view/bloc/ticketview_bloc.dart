import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/repository/api_tickets_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'ticketview_event.dart';
part 'ticketview_state.dart';

class TicketViewBloc extends Bloc<TicketViewEvent, TicketViewState> {
  final ApiTicketsRepository _ticketsRepository;

  TicketViewBloc() : 
  _ticketsRepository = new ApiTicketsRepository(),
  super(TicketViewInitial(null));

  @override
  Stream<TicketViewState> mapEventToState(
    TicketViewEvent event,
  ) async* {
    if (event is GetTicketDetails) {
      yield* _mapGetTicketDetailsToState(event);
    }
  }

  Stream<TicketViewState> _mapGetTicketDetailsToState(GetTicketDetails event) async* {
    yield TicketViewLoading(state.ticket);
    try{
      Ticket? ticket = await _ticketsRepository.getTicketById(event.ticketId);
            
      yield TicketViewSuccess(ticket);
            
    }on CustomException catch(e){
      yield TicketViewError(state.ticket, e.toString());
    }
      
  }
}
