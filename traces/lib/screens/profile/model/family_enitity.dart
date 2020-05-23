import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyEntity extends Equatable{
  final String name;
  final String gender;
  final String id;

  FamilyEntity(this.id, this.name, this.gender);

  @override
  List<Object> get props => [id, name, gender];

  static FamilyEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return FamilyEntity(
        documentId,
        map["name"] as String,
        map["gender"] as String
    );
  }

  static FamilyEntity fromSnapshot(DocumentSnapshot snap){
    return FamilyEntity(
        snap.documentID,
        snap.data["name"],
        snap.data["gender"]
    );
  }

  Map<String, Object> toDocument(){
    return{
      "name": name,
      "gender": gender
    };
  }
}