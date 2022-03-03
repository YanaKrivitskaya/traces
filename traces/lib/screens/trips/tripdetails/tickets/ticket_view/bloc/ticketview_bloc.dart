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
  super(TicketViewInitial(null)){
    on<GetTicketDetails>((event, emit) async{
      emit(TicketViewLoading(state.ticket));
    try{
      Ticket? ticket = await _ticketsRepository.getTicketById(event.ticketId);
            
      emit(TicketViewSuccess(ticket));
            
    }on CustomException catch(e){
      emit(TicketViewError(state.ticket, e.toString()));
    }
    });
  }  
}
