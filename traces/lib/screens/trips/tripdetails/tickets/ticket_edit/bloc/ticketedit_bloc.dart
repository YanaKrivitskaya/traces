import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/repository/api_tickets_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'ticketedit_event.dart';
part 'ticketedit_state.dart';

class TicketEditBloc extends Bloc<TicketEditEvent, TicketEditState> {
  final ApiTicketsRepository _ticketsRepository;
  
  TicketEditBloc() : 
  _ticketsRepository = new ApiTicketsRepository(),
  super(TicketCreateInitial(null));

  @override
  Stream<TicketEditState> mapEventToState(
    TicketEditEvent event,
  ) async* {
    if (event is NewTicketMode) {
      yield* _mapNewTicketModeToState(event);
    } else if (event is ArrivalDateUpdated) {
      yield* _mapArrivalDateUpdatedToState(event);
    } else if (event is DepartureDateUpdated) {
      yield* _mapDepartureDateUpdatedToState(event);
    }  else if (event is TicketSubmitted) {
      yield* _mapTicketSubmittedToState(event);
    } else if (event is ExpenseUpdated) {
      yield* _mapExpenseUpdatedToState(event);
    } else if (event is EditTicketMode) {
      yield* _mapEditTicketModeToState(event);
    }
  }

  Stream<TicketEditState> _mapNewTicketModeToState(NewTicketMode event) async* {
    yield TicketCreateEdit(new Ticket(departureDatetime: event.date), false);
  }

  Stream<TicketEditState> _mapEditTicketModeToState(EditTicketMode event) async* {
    yield TicketCreateEdit(event.ticket, false);
  }

  Stream<TicketEditState> _mapArrivalDateUpdatedToState(ArrivalDateUpdated event) async* {
    
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(arrivalDatetime: event.arrivalDate);

    yield TicketCreateEdit(updTicket, false);
  }

  Stream<TicketEditState> _mapDepartureDateUpdatedToState(DepartureDateUpdated event) async* {
    
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(departureDatetime: event.departureDate);

    yield TicketCreateEdit(updTicket, false);
  }

  Stream<TicketEditState> _mapExpenseUpdatedToState(ExpenseUpdated event) async* {
    
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(expense: event.expense);

    yield TicketCreateEdit(updTicket, false);
  }

  Stream<TicketEditState> _mapTicketSubmittedToState(TicketSubmitted event) async* {
    yield TicketCreateEdit(event.ticket, true);    

    try{
      Ticket ticket;
      if(event.ticket!.id != null){
        ticket = await _ticketsRepository.updateTicket(event.ticket!, event.ticket!.expense, event.tripId);
      } else {
        ticket = await _ticketsRepository.createTicket(event.ticket!, event.expense, event.userId, event.tripId);
      }
      
      yield TicketCreateSuccess(ticket);
    }on CustomException catch(e){
        yield TicketCreateError(event.ticket, e.toString());
    }   
  }
}
