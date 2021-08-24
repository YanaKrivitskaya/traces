import 'package:traces/screens/trips/model/api_models/api_ticket.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';

import '../../../utils/services/api_service.dart';

class ApiTicketsRepository{
  ApiService apiProvider = ApiService();
  String ticketsUrl = 'tickets/';

  Future<List<Ticket>?> getTripTickets(int tripId) async{    
    print("getTripTickets");
    
    final queryParameters = {
      'tripid': tripId
    };
    final response = await apiProvider.getSecure(ticketsUrl, queryParams: queryParameters);
      
    var ticketResponse = response["tickets"] != null ? 
      response['tickets'].map<Ticket>((map) => Ticket.fromMap(map)).toList() : null;
    return ticketResponse;
  }

  Future<Ticket?> getTicketById(int ticketId) async{
    print("getTicketById");
    final response = await apiProvider.getSecure("$ticketsUrl$ticketId");
      
    var ticketResponse = response["ticket"] != null ? 
      Ticket.fromMap(response['ticket']) : null;
    return ticketResponse;
    }

    Future<Ticket> createTicket(Ticket ticket, Expense? expense, int? userId, int tripId)async{
    print("createTicket");

    ApiTicketModel apiModel = ApiTicketModel(userId: userId, ticket: ticket, expense: expense, tripId: tripId);

    final response = await apiProvider.postSecure(ticketsUrl, apiModel.toJson());
      
    var ticketResponse = Ticket.fromMap(response['tickets']);
    return ticketResponse;
  }

  Future<Ticket> updateTicket(Ticket ticket)async{
    print("updateTicket");

    final response = await apiProvider.putSecure("$ticketsUrl${ticket.id}", ticket.toJson());
      
    var ticketResponse = Ticket.fromMap(response['tickets']);
    return ticketResponse;
  }

  Future<String?> deleteTicket(int ticketId)async{
    print("deleteTicket");   

    final response = await apiProvider.deleteSecure("$ticketsUrl$ticketId}");     
    
    return response["response"];
  } 
}