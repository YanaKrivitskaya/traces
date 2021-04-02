
import 'package:traces/screens/trips/model/trip.dart';

abstract class TripsRepository{
  Future<Trip> addnewTrip(Trip trip);
  Future<Trip> getTripById(String id);
  Stream<List<Trip>> trips();
}