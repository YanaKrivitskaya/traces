import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEntity extends Equatable{
  final String? email;
  final String? displayName;
  final bool? isEmailVerified;
  final String? id;  

  ProfileEntity(this.id, this.email, this.displayName, this.isEmailVerified);

  @override
  List<Object?> get props => [id, email, displayName, isEmailVerified];

  static ProfileEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return ProfileEntity(
        documentId,        
        map["email"] as String?,
        map["displayName"] as String?,
        map["isEmailVerified"] as bool?
    );
  }

  static ProfileEntity fromSnapshot(DocumentSnapshot snap){
    return ProfileEntity(
        snap.id,        
        snap["email"],
        snap["displayName"],
        snap["isEmailVerified"]
    );
  }

  Map<String, Object?> toDocument(){
    return{
      "email": email,
      "displayName": displayName,
      "isEmailVerified": isEmailVerified ?? false
    };
  }
}