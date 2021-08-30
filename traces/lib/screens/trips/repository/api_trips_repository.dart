import 'package:traces/screens/trips/model/api_trip_user.model.dart';
import 'package:traces/screens/trips/model/trip.model.dart';

import '../../../utils/services/api_service.dart';

class ApiTripsRepository{
  ApiService apiProvider = ApiService();
  String tripsUrl = 'trips/';

  Future<List<Trip>?> getTrips() async{    
    print("getTrips");
    final response = await apiProvider.getSecure(tripsUrl);
      
    var tripResponse = response["trips"] != null ? 
      response['trips'].map<Trip>((map) => Trip.fromMap(map)).toList() : null;
    return tripResponse;
  }

  Future<Trip?> getTripById(int tripId) async{
    print("getTripById");
    final response = await apiProvider.getSecure("$tripsUrl$tripId");
      
    var tripResponse = response["trip"] != null ? 
      Trip.fromMap(response['trip']) : null;
    return tripResponse;
    }

    Future<Trip> createTrip(Trip trip, int userId)async{
    print("createTrip");

    //ApiTripModel apiModel = ApiTripModel(userId: userId, trip: trip);

    final response = await apiProvider.postSecure(tripsUrl, trip.toJson());
      
    var tripResponse = Trip.fromMap(response['trip']);
    return tripResponse;
  }

  Future<Trip> updateTrip(Trip trip, int userId)async{
    print("updateTrip");
    
    //ApiTripModel apiModel = ApiTripModel(userId: userId, trip: trip);

    final response = await apiProvider.putSecure("$tripsUrl${trip.id}", trip.toJson());
      
    var tripResponse = Trip.fromMap(response['trip']);
    return tripResponse;
  }

  Future<Trip> updateTripUsers(int tripId, List<int> userIds)async{
    print("updateTripUsers");
    
    ApiTripUsersModel apiModel = ApiTripUsersModel(userIds);

    final response = await apiProvider.putSecure("$tripsUrl$tripId/users", apiModel.toJson());
      
    var tripResponse = Trip.fromMap(response['trip']);
    return tripResponse;
  }

  Future<String?> deleteTrip(int tripId)async{
    print("deleteTrip");   

    final response = await apiProvider.deleteSecure("$tripsUrl$tripId}");     
    
    return response["response"];
  } 
}