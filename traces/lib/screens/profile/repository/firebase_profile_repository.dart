import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/family_enitity.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/model/profile_entity.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseProfileRepository extends ProfileRepository{
  final usersCollection = Firestore.instance.collection('users');
  final String userFamily = "family";

  UserRepository _userRepository;

  FirebaseProfileRepository() {
    _userRepository = new UserRepository();
    Firestore.instance.settings(persistenceEnabled: true);
  }

  @override
  Stream<List<Family>> familyMembers() async* {
    String uid = await _userRepository.getUserId();
    yield* usersCollection.document(uid).collection(userFamily).snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Family.fromEntity(FamilyEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> addNewFamilyMember(Family family) async {
    String uid = await _userRepository.getUserId();
    return await usersCollection.document(uid).collection(userFamily).add(family.toEntity().toDocument());
    //return await getFamilyById(newFamilyMember.documentID);
  }

  @override
  Future<void> deleteFamilyMember(Family family) async {
    String uid = await _userRepository.getUserId();
    return usersCollection.document(uid).collection(userFamily).document(family.id).delete();
  }

  @override
  Future<Family> getFamilyById(String id) async {
    String uid = await _userRepository.getUserId();

    var resultNote = await usersCollection.document(uid).collection(userFamily).document(id).get();

    return Family.fromEntity(FamilyEntity.fromMap(resultNote.data, resultNote.documentID));
  }

  @override
  Future<Profile> getCurrentProfile() async {
    String uid = await _userRepository.getUserId();

    var resultProfile = await usersCollection.document(uid).get();

    if(resultProfile.exists){
      return Profile.fromEntity(ProfileEntity.fromMap(resultProfile.data, resultProfile.documentID));
    }

    return null;
  }

  @override
  Future<void> updateFamilyMember(Family family) async {
    String uid = await _userRepository.getUserId();
    return await usersCollection.document(uid).collection(userFamily)
        .document(family.id)
        .updateData(family.toEntity().toDocument());
    //return await getFamilyById(family.id);
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    String uid = await _userRepository.getUserId();
    await usersCollection.document(uid)
        .updateData(profile.toEntity().toDocument());
    return await getCurrentProfile();
  }

  @override
  Future<void> updateUsername(String username) async{
    FirebaseUser user = await _userRepository.getUser();

    UserUpdateInfo profileUpdate = UserUpdateInfo();
    profileUpdate.displayName = username;

    return await user.updateProfile(profileUpdate);
  }

  @override
  Future<Profile> addNewProfile() async {
    FirebaseUser user = await _userRepository.getUser();

    Profile newProfile = Profile(user.email, displayName: user.displayName, isEmailVerified: user.isEmailVerified);
    await usersCollection.document(user.uid).setData(newProfile.toEntity().toDocument());

    return await getCurrentProfile();
  }

}