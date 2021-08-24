import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/repository/api_profile_repository.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';
import 'package:traces/screens/trips/repository/api_tickets_repository.dart';
import 'package:traces/screens/trips/repository/api_trips_repository.dart';
import 'package:traces/utils/api/customException.dart';

part 'ticketcreate_event.dart';
part 'ticketcreate_state.dart';

class TicketCreateBloc extends Bloc<TicketCreateEvent, TicketCreateState> {
  final ApiTicketsRepository _ticketsRepository;
  final ApiProfileRepository _profileRepository;
  
  TicketCreateBloc() : 
  _ticketsRepository = new ApiTicketsRepository(),
  _profileRepository = new ApiProfileRepository(),
  super(TicketCreateInitial(null));

  @override
  Stream<TicketCreateState> mapEventToState(
    TicketCreateEvent event,
  ) async* {
    if (event is NewTicketMode) {
      yield* _mapNewTicketModeToState(event);
    } else if (event is ArrivalDateUpdated) {
      yield* _mapArrivalDateUpdatedToState(event);
    } else if (event is DepartureDateUpdated) {
      yield* _mapDepartureDateUpdatedToState(event);
    }  else if (event is TicketSubmitted) {
      yield* _mapTicketSubmittedToState(event);
    }
  }

   Stream<TicketCreateState> _mapNewTicketModeToState(NewTicketMode event) async* {
    yield TicketCreateEdit(new Ticket(), false);
  }

  Stream<TicketCreateState> _mapArrivalDateUpdatedToState(ArrivalDateUpdated event) async* {
    
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(arrivalDatetime: event.arrivalDate);

    yield TicketCreateEdit(updTicket, false);
  }

  Stream<TicketCreateState> _mapDepartureDateUpdatedToState(DepartureDateUpdated event) async* {
    
    Ticket ticket = state.ticket ?? new Ticket();

    Ticket updTicket = ticket.copyWith(departureDatetime: event.departureDate);

    yield TicketCreateEdit(updTicket, false);
  }

  Stream<TicketCreateState> _mapTicketSubmittedToState(TicketSubmitted event) async* {
    yield TicketCreateEdit(event.ticket, true);
    print(event.ticket.toString());

    try{
      Ticket ticket = await _ticketsRepository.createTicket(event.ticket!, event.expense, event.userId, event.tripId);
      yield TicketCreateSuccess(ticket);
    }on CustomException catch(e){
        yield TicketCreateError(event.ticket, e.toString());
    }

    /*if(event.trip!.startDate == null || event.trip!.endDate == null){
      var error = 'Please choose the dates';
      yield StartPlanningErrorState(event.trip, error);
    }
    else{
      try{
        var profile = await _profileRepository.getProfileWithGroups();      
        var familyGroup = profile.groups!.firstWhere((g) => g.name == "Family");

        Group family = await _profileRepository.getGroupUsers(familyGroup.id!);
        event.trip!.users = [family.users.firstWhere((u) => u.accountId == profile.accountId)];

        Trip trip = await _tripsRepository.createTrip(event.trip!, profile.accountId);        

        yield TicketCreateSuccess(ticket);
      } on CustomException catch(e){
        
      }
      
    }    */
  }
}