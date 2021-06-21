import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VisaEntity extends Equatable{
  final String? id;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? countryOfIssue;
  final int? durationOfStay;
  final String? numberOfEntries;
  final String? owner;
  final String? type;
  final DateTime? dateCreated;
  final DateTime? dateModified;

  VisaEntity(this.id, this.startDate, this.endDate, this.countryOfIssue,
      this.durationOfStay, this.numberOfEntries, this.type, this.owner, this.dateCreated, this.dateModified);

  @override
  List<Object?> get props => [this.id, this.startDate, this.endDate,
    this.countryOfIssue, this.durationOfStay, this.numberOfEntries, this.type, this.owner, dateCreated, dateModified];

  Map<String, Object?> toJson(){
    return{
      "id": id,
      "startDate": startDate,
      "endDate": endDate,
      "country": countryOfIssue,
      "durationOfStay": durationOfStay,
      "numberOfEntries": numberOfEntries,
      "type": type,
      "owner": owner,
      "dateCreated": dateCreated,
      "dateModified": dateModified,
    };
  }

  static VisaEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return VisaEntity(
        documentId,
        map["startDate"].toDate(),
        map["endDate"].toDate(),
        map["country"] as String?,
        map["durationOfStay"] as int?,
        map["numberOfEntries"] as String?,
        map["type"] as String?,
        map["owner"] as String?,
        map["dateCreated"].toDate(),
        map["dateModified"].toDate(),
    );
  }

  static VisaEntity fromSnapshot(DocumentSnapshot snap){
    return VisaEntity(
        snap.id,
        snap['startDate'].toDate(),
        snap['endDate'].toDate(),
        snap['country'],
        snap['durationOfStay'],
        snap['numberOfEntries'],
        snap['type'],
        snap['owner'],
        snap['dateCreated'].toDate(),
        snap['dateModified'].toDate(),
    );
  }

  Map<String, Object?> toDocument(){
    return{
      "startDate": startDate,
      "endDate": endDate,
      "country": countryOfIssue,
      "durationOfStay": durationOfStay,
      "numberOfEntries": numberOfEntries,
      "type": type,
      "owner": owner,
      "dateCreated": dateCreated,
      "dateModified": DateTime.now(),
    };
  }

}