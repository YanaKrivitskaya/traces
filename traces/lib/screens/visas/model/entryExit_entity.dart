import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryExitEntity extends Equatable{
  final String id;
  final DateTime entryDate;
  final String entryCountry;
  final String entryCity;
  final String entryTransport;
  final DateTime exitDate;
  final String exitCountry;
  final String exitCity;
  final String exitTransport;
  final bool hasExit;

  EntryExitEntity(this.id, this.entryDate, this.entryCountry, this.entryCity, this.entryTransport, this.exitDate,
      this.exitCountry, this.exitCity, this.exitTransport, this.hasExit);

  Map<String, Object> toJson(){
    return{
      "id": id,
      "entryDate": entryDate,
      "entryCountry": entryCountry,
      "entryCity": entryCity,
      "entryTransport": entryTransport,
      "exitDate": exitDate,
      "exitCountry": exitCountry,
      "exitCity": exitCity,
      "exitTransport": exitTransport,
      "hasExit": hasExit
    };
  }

  @override
  List<Object> get props => [id, entryDate, exitDate, hasExit, entryCountry, entryDate, entryTransport, entryCity, exitTransport, exitCity];

  static EntryExitEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return EntryExitEntity(
        documentId,
        map["entryDate"].toDate(),
        map["entryCountry"],
        map["entryCity"],
        map["entryTransport"],
        map["exitDate"].toDate(),
        map["exitCountry"],
        map["exitCity"],
        map["exitTransport"],
        map["hasExit"]
    );
  }

  static EntryExitEntity fromSnapshot(DocumentSnapshot snap){
    return EntryExitEntity(
        snap.id,
        snap.data()['entryDate'].toDate(),
        snap.data()['entryCountry'],
        snap.data()['entryCity'],
        snap.data()['entryTransport'],
        snap.data()['exitDate'] != null ? snap.data()['exitDate'].toDate() : null,
        snap.data()['exitCountry'],
        snap.data()['exitCity'],
        snap.data()['exitTransport'],
        snap.data()['hasExit']
    );
  }

  Map<String, Object> toDocument(){
    return{
      "entryDate": entryDate,
      "entryCountry": entryCountry,
      "entryCity": entryCity,
      "entryTransport": entryTransport,
      "exitDate": exitDate,
      "exitCountry": exitCountry,
      "exitCity": exitCity,
      "exitTransport": exitTransport,
      "hasExit": hasExit,
    };
  }

}