import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DayActionEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime date;
  final bool isPlanned;
  final bool isCompleted;
  final String photoUrl;

  const DayActionEntity(
    this.id, 
    this.name, 
    this.description, 
    this.date, 
    this.isPlanned, 
    this.isCompleted, 
    this.photoUrl
  );  

  @override  
  List<Object> get props {
    return [id, name, description, date, isPlanned, isCompleted, photoUrl];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'date': date,
      'isPlanned': isPlanned,
      'isCompleted': isCompleted,
      'photoUrl': photoUrl,
    };
  }

  factory DayActionEntity.fromMap(Map<String, dynamic> map) {
    return DayActionEntity(
      map['id'],
      map['name'],
      map['description'],
      map['date'],
      map['isPlanned'],
      map['isCompleted'],
      map['photoUrl'],
    );
  }

  static DayActionEntity fromSnapshot(DocumentSnapshot snap){
    return DayActionEntity(
      snap.id, 
      snap.data()['name'], 
      snap.data()['description'], 
      snap.data()['date'].toDate(), 
      snap.data()['isPlanned'] as bool, 
      snap.data()['isCompleted'] as bool, 
      snap.data()['photoUrl']
    );
  }

  Map<String, Object> toDocument(){
    return{
      "name": name,
      "description": description!= '' ? description : 'No description',
      "date": date,
      "isPlanned": isPlanned,
      "isCompleted": isCompleted,
      "photoUrl": photoUrl
    };
  }

  String toJson() => json.encode(toMap());

  factory DayActionEntity.fromJson(String source) => DayActionEntity.fromMap(json.decode(source));

  @override
  bool get stringify => true;


  /*static DayActionEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return DayActionEntity(
      documentId, 
      map["name"] as String, 
      map["description"] as String,
      map["date"].toDate(), 
      map["isPlanned"] as bool, 
      map["isCompleted"] as bool, 
      map["photoUrl"] as String
    );  
  }*/
  /*Map<String, Object> toJson(){
    return{
      "id": id,
      "name": name,
      "description": description,
      "date": date,
      "isPlanned": isPlanned,
      "isCompleted": isCompleted,
      "photoUrl": photoUrl
    };
  }*/
  
}
