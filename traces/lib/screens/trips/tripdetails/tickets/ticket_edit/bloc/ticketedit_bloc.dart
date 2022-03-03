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
  super(TicketCreateInitial(null)){
    on<NewTicketMode>((event, emit) => emit(
      TicketCreateEdit(
        new Ticket(departureDatetime: event.date), 
        false)));
    on<EditTicketMode>((event, emit) => emit(TicketCreateEdit(event.ticket, false)));  
    on<ArrivalDateUpdated>(_onArrivalDateUpdated);
    on<DepartureDateUpdated>(_onDepartureDateUpdated);  
    on<TicketSubmitted>(_onTicketSubmitted);  
    on<ExpenseUpdated>(_onExpenseUpdated);  
  } 

  void _onArrivalDateUpdated(ArrivalDateUpdated event, Emitter<TicketEditState> emit) async{
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(arrivalDatetime: event.arrivalDate);

    emit(TicketCreateEdit(updTicket, false));
  } 

  void _onDepartureDateUpdated(DepartureDateUpdated event, Emitter<TicketEditState> emit) async{
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(departureDatetime: event.departureDate);

    emit(TicketCreateEdit(updTicket, false));
  } 

  void _onExpenseUpdated(ExpenseUpdated event, Emitter<TicketEditState> emit) async{
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(expense: event.expense);

    emit(TicketCreateEdit(updTicket, false));
  } 

  void _onTicketSubmitted(TicketSubmitted event, Emitter<TicketEditState> emit) async{
    emit(TicketCreateEdit(event.ticket, true));    

    try{
      Ticket ticket;
      if(event.ticket!.id != null){
        ticket = await _ticketsRepository.updateTicket(event.ticket!, event.ticket!.expense, event.tripId);
      } else {
        ticket = await _ticketsRepository.createTicket(event.ticket!, event.expense, event.userId, event.tripId);
      }
      
      emit(TicketCreateSuccess(ticket));
    }on CustomException catch(e){
        emit(TicketCreateError(event.ticket, e.toString()));
    }  
  } 
}
