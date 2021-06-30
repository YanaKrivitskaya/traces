import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberEntity extends Equatable{
  final String? id;
  final String? name;

  MemberEntity(this.id, this.name);

  @override
  List<Object?> get props => [id, name];

  static MemberEntity fromMap(Map<dynamic, dynamic> map){
    return MemberEntity(
      map['id'],
      map["name"] as String?
    );
  }

  static MemberEntity fromSnapshot(DocumentSnapshot snap){
    return MemberEntity(
      snap.id,
      snap["name"]
    );
  }

  Map<String, Object?> toDocument(){
    return{
      "name": name
    };
  }
}