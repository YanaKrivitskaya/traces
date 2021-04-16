import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/model/trip_entity.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

class FirebaseTripsRepository extends TripsRepository{
  final tripsCollection = FirebaseFirestore.instance.collection('trips');
  final String userTrips = "userTrips";
  final String tripsDays = "tripDays";
  final String tripActions = "tripActions";

  UserRepository _userRepository;

  FirebaseTripsRepository() {
    _userRepository = new UserRepository();    
  }

  @override
  Future<Trip> addnewTrip(Trip trip) async{
    String uid = await _userRepository.getUserId();
    final newTrip = await tripsCollection.doc(uid).collection(userTrips).add(trip.toEntity().toDocument()); 
    return await getTripById(newTrip.id);
  }
  @override
  Future<Trip> getTripById(String id) async{
    String uid = await _userRepository.getUserId();

    var trip = await tripsCollection.doc(uid).collection(userTrips).doc(id).get();

    return Trip.fromEntity(TripEntity.fromMap(trip.data()));
  }
  
  @override
  Stream<List<Trip>> trips() async* {
    String uid = await _userRepository.getUserId();

    yield* tripsCollection.doc(uid).collection(userTrips).snapshots()
    .map((snap){
      return snap.docs
        .map((doc) => Trip.fromEntity(TripEntity.fromSnapshot(doc)))
        .toList();
    });
  }
}