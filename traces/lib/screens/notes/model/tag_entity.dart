import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TagEntity extends Equatable{
  final String id;
  final String name;
  final int usage;

  TagEntity(this.id, this.name, this.usage);

  @override
  List<Object> get props => [id, name, usage];

  static TagEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return TagEntity(
      documentId,
      map["name"] as String,
      map["usage"] as int
    );
  }

  static TagEntity fromSnapshot(DocumentSnapshot snap){
    return TagEntity(
        snap.id,
        snap.data()["name"],
        snap.data()["usage"]
    );
  }

  Map<String, Object> toDocument(){
    return{
      "name": name,
      "usage": usage
    };
  }

}