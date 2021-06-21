
import 'package:traces/screens/trips/model/trip.dart';

abstract class TripsRepository{
  Future<Trip> addnewTrip(Trip? trip);
  Future<Trip> getTripById(String? id);
  Stream<List<Trip>> trips();
  Future<Trip> updateTrip(Trip updTrip);
  Future<Trip> updateTripMembers(String? tripId, List<String?> members);
  Future<void> deleteTrip(String? tripId);
}