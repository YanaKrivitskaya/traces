import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisaEntity extends Equatable{
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String countryOfIssue;
  final String durationOfStay;
  final String numberOfEntries;
  final String memberId;
  final List<String> entryExitIds;
  final String type;
  final DateTime dateCreated;
  final DateTime dateModified;

  VisaEntity(this.id, this.startDate, this.endDate, this.countryOfIssue,
      this.durationOfStay, this.numberOfEntries, this.entryExitIds, this.type, this.memberId, this.dateCreated, this.dateModified);

  @override
  List<Object> get props => [this.id, this.startDate, this.endDate,
    this.countryOfIssue, this.durationOfStay, this.numberOfEntries, this.entryExitIds,  this.type, this.memberId, dateCreated, dateModified];

  Map<String, Object> toJson(){
    return{
      "id": id,
      "startDate": startDate,
      "endDate": endDate,
      "country": countryOfIssue,
      "durationOfStay": durationOfStay,
      "numberOfEntries": numberOfEntries,
      "entryExitIds": entryExitIds,
      "type": type,
      "memberId": memberId,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
    };
  }

  static VisaEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return VisaEntity(
        documentId,
        map["startDate"].toDate(),
        map["endDate"].toDate(),
        map["country"] as String,
        map["durationOfStay"] as String,
        map["numberOfEntries"] as String,
        map["entryExitIds"] != null ? map["entryExitIds"].cast<String>() as List<String> : null,
        map["type"] as String,
        map["memberId"] as String,
        map["dateCreated"].toDate(),
        map["dateModified"].toDate(),
    );
  }

  static VisaEntity fromSnapshot(DocumentSnapshot snap){
    return VisaEntity(
        snap.documentID,
        snap.data['startDate'].toDate(),
        snap.data['endDate'].toDate(),
        snap.data['country'],
        snap.data['durationOfStay'],
        snap.data['numberOfEntries'],
        snap.data['entryExitIds']!= null ? snap.data['entryExitIds'].cast<String>() : null,
        snap.data['type'],
        snap.data['memberId'],
        snap.data['dateCreated'].toDate(),
        snap.data['dateModified'].toDate(),
    );
  }

  Map<String, Object> toDocument(){
    return{
      "startDate": startDate,
      "endDate": endDate,
      "country": countryOfIssue,
      "durationOfStay": durationOfStay,
      "numberOfEntries": numberOfEntries,
      "entryExitIds": entryExitIds,
      "type": type,
      "memberId": memberId,
      "dateCreated": dateCreated,
      "dateModified": DateTime.now(),
    };
  }

}