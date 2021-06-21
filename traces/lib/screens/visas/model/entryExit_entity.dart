import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EntryExitEntity extends Equatable{
  final String? id;
  final DateTime? entryDate;
  final String? entryCountry;
  final String? entryCity;
  final String? entryTransport;
  final DateTime? exitDate;
  final String? exitCountry;
  final String? exitCity;
  final String? exitTransport;
  final int? duration;
  final bool? hasExit;

  EntryExitEntity(this.id, this.entryDate, this.entryCountry, this.entryCity, this.entryTransport, this.exitDate,
      this.exitCountry, this.exitCity, this.exitTransport, this.duration, this.hasExit);

  Map<String, Object?> toJson(){
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
      "duration": duration,
      "hasExit": hasExit
    };
  }

  @override
  List<Object?> get props => [id, entryDate, exitDate, hasExit, entryCountry, entryDate, entryTransport, entryCity, exitTransport, exitCity, duration];

  static EntryExitEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return EntryExitEntity(
        documentId,
        map["entryDate"].toDate(),
        map["entryCountry"],
        map["entryCity"],
        map["entryTransport"],
        map["exitDate"] != null ? map["exitDate"].toDate() : null,
        map["exitCountry"],
        map["exitCity"],
        map["exitTransport"], 
        map["duration"],
        map["hasExit"]
    );
  }

  static EntryExitEntity fromSnapshot(DocumentSnapshot snap){
    return EntryExitEntity(
        snap.id,
        snap['entryDate'].toDate(),
        snap['entryCountry'],
        snap['entryCity'],
        snap['entryTransport'],
        snap['exitDate'] != null ? snap['exitDate'].toDate() : null,
        snap['exitCountry'],
        snap['exitCity'],
        snap['exitTransport'],
        snap['duration'],
        snap['hasExit']
    );
  }

  Map<String, Object?> toDocument(){
    return{
      "entryDate": entryDate,
      "entryCountry": entryCountry,
      "entryCity": entryCity,
      "entryTransport": entryTransport,
      "exitDate": exitDate,
      "exitCountry": exitCountry,
      "exitCity": exitCity,
      "exitTransport": exitTransport,
      "duration": duration,
      "hasExit": hasExit,
    };
  }

}