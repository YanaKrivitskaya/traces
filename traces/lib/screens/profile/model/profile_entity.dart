import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEntity extends Equatable{
  final String email;
  final String displayName;
  final bool isEmailVerified;
  final String id;
  final List<String> familyMembers;

  ProfileEntity(this.id, this.familyMembers, this.email, this.displayName, this.isEmailVerified);

  @override
  List<Object> get props => [id, familyMembers, email, displayName, isEmailVerified];

  static ProfileEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return ProfileEntity(
        documentId,
        map["familyMembers"] != null ? map["familyMembers"].cast<String>() as List<String> : <String>[],
        map["email"] as String,
        map["displayName"] as String,
        map["isEmailVerified"] as bool
    );
  }

  static ProfileEntity fromSnapshot(DocumentSnapshot snap){
    return ProfileEntity(
        snap.id,
        snap.data()["familyMembers"].cast<String>(),
        snap.data()["email"],
        snap.data()["displayName"],
        snap.data()["isEmailVerified"]
    );
  }

  Map<String, Object> toDocument(){
    return{
      "email": email,
      "displayName": displayName,
      "isEmailVerified": isEmailVerified ?? false,
      "familyMembers": familyMembers,
    };
  }
}