import 'package:traces/screens/trips/model/api_models/api_booking.model.dart';
import 'package:traces/screens/trips/model/booking.model.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

import '../../../utils/services/api_service.dart';

class ApiBookingsRepository{
  ApiService apiProvider = ApiService();
  String bookingsUrl = 'bookings/';

  Future<List<Booking>?> getTripBookings(int tripId) async{    
    print("getTripBookings");
    
    final queryParameters = {
      'tripId': tripId.toString()
    };
    final response = await apiProvider.getSecure(bookingsUrl, queryParams: queryParameters);
      
    var bookingResponse = response["bookings"] != null ? 
      response['bookings'].map<Booking>((map) => Booking.fromMap(map)).toList() : null;
    return bookingResponse;
  }

  Future<Booking?> getBookingById(int bookingId) async{
    print("getBookingById");
    final response = await apiProvider.getSecure("$bookingsUrl$bookingId");
      
    var bookingResponse = response["booking"] != null ? 
      Booking.fromMap(response['booking']) : null;
    return bookingResponse;
    }

    Future<Booking> createBooking(Booking booking, Expense? expense, int tripId)async{
    print("createBooking");

    ApiBookingModel apiModel = ApiBookingModel(booking: booking, expense: expense, tripId: tripId);

    final response = await apiProvider.postSecure(bookingsUrl, apiModel.toJson());
      
    var bookingResponse = Booking.fromMap(response['bookings']);
    return bookingResponse;
  }

  Future<Booking> updateBooking(Booking booking, Expense? expense, int tripId)async{
    print("updateBooking");

    ApiBookingModel apiModel = ApiBookingModel(booking: booking, expense: expense, tripId: tripId);

    final response = await apiProvider.putSecure("$bookingsUrl${booking.id}", apiModel.toJson());
      
    var bookingResponse = Booking.fromMap(response['bookings']);
    return bookingResponse;
  }

  Future<String?> deleteBooking(int bookingId)async{
    print("deleteBooking");   

    final response = await apiProvider.deleteSecure("$bookingsUrl$bookingId}");     
    
    return response["response"];
  } 
}