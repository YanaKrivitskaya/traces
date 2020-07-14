import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryExitEntity extends Equatable{
  final String id;
  final DateTime entryDate;
  final String entryCountry;
  final DateTime exitDate;
  final String exitCountry;
  final bool hasExit;

  EntryExitEntity(this.id, this.entryDate, this.exitDate, this.hasExit, this.entryCountry, this.exitCountry);

  Map<String, Object> toJson(){
    return{
      "id": id,
      "entryCountry": entryCountry,
      "exitCountry": exitCountry,
      "entryDate": entryDate,
      "exitDate": exitDate,
      "hasExit": hasExit
    };
  }

  @override
  List<Object> get props => [id, entryDate, exitDate, hasExit, entryCountry, entryDate];

  static EntryExitEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return EntryExitEntity(
        documentId,
        map["entryDate"].toDate(),
        map["entryCountry"],
        map["exitDate"].toDate(),
        map["exitCountry"],
        map["hasExit"]
    );
  }

  static EntryExitEntity fromSnapshot(DocumentSnapshot snap){
    return EntryExitEntity(
        snap.documentID,
        snap.data['entryDate'].toDate(),
        snap.data['entryCountry'],
        snap.data['exitDate'].toDate(),
        snap.data['exitCountry'],
        snap.data['hasExit']
    );
  }

  Map<String, Object> toDocument(){
    return{
      "entryDate": entryDate,
      "exitDate": exitDate,
      "hasExit": hasExit,
      "entryCountry": entryCountry,
      "exitCountry": exitCountry,
    };
  }

}