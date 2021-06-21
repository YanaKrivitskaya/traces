import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/screens/trips/model/trip.dart';
import 'package:traces/screens/trips/model/trip_entity.dart';
import 'package:traces/screens/trips/repository/trips_repository.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseTripsRepository extends TripsRepository{
  final tripsCollection = FirebaseFirestore.instance.collection('trips');
  final String userTrips = "userTrips";
  final String tripsDays = "tripDays";
  final String tripActions = "tripActions";

  final storage = firebase_storage.FirebaseStorage.instance;

  //FirebaseUserRepository _userRepository;

  FirebaseTripsRepository() {
    //_userRepository = new FirebaseUserRepository();    
  }

  @override
  Future<Trip> addnewTrip(Trip trip) async{
    /*String uid = await _userRepository.getUserId();
    var tripEntity = trip.toEntity().toDocument();
    final newTrip = await tripsCollection.doc(uid).collection(userTrips).add(tripEntity);
    return await getTripById(newTrip.id);*/
  }
  
  @override
  Future<Trip> getTripById(String id) async{
   /* String uid = await _userRepository.getUserId();

    var trip = await tripsCollection.doc(uid).collection(userTrips).doc(id).get();
    return Trip.fromEntity(TripEntity.fromMap(trip.data(), trip.id));*/
  }
  
  @override
  Stream<List<Trip>> trips() async* {
    /*String uid = await _userRepository.getUserId();

    var res = await storage.ref().child('trips').child('beach.jpg').getDownloadURL();

    print(res);

    yield* tripsCollection.doc(uid).collection(userTrips).snapshots()
    .map((snap){
      return snap.docs
        .map((doc) => Trip.fromEntity(TripEntity.fromSnapshot(doc)))
        .toList();
    });*/
  }

  @override
  Future<Trip> updateTrip(Trip updTrip) async{
    /*String uid = await _userRepository.getUserId();

    await tripsCollection.doc(uid).collection(userTrips).doc(updTrip.id)
      .update(updTrip.toEntity().toDocument());

    return await getTripById(updTrip.id);*/
  }

  @override
  Future<Trip> updateTripMembers(String tripId, List<String> members) async{
    /*String uid = await _userRepository.getUserId();

    await tripsCollection.doc(uid).collection(userTrips).doc(tripId)
      .update({"tripMembers": members});

    return await getTripById(tripId);*/
  }

  @override
  Future<void> deleteTrip(String tripId) async{
   /* String uid = await _userRepository.getUserId();

    await tripsCollection.doc(uid).collection(userTrips).doc(tripId).delete();*/
  }
}