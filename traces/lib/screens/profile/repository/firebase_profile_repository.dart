import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/profile/model/profile.dart';
import 'package:traces/screens/profile/model/profile_entity.dart';
import 'package:traces/screens/profile/repository/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseProfileRepository extends ProfileRepository{
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final String userFamily = "family";

  UserRepository _userRepository;

  FirebaseProfileRepository() {
    _userRepository = new UserRepository();
    //Firestore.instance.settings(persistenceEnabled: true);
  }

  @override
  Future<Profile> getCurrentProfile() async {
    String uid = await _userRepository.getUserId();

    var resultProfile = await usersCollection.doc(uid).get();

    if(resultProfile.exists){
      return Profile.fromEntity(ProfileEntity.fromMap(resultProfile.data(), resultProfile.id));
    }

    return null;
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    String uid = await _userRepository.getUserId();
    await usersCollection.doc(uid)
        .update(profile.toEntity().toDocument());
    return await getCurrentProfile();
  }

  @override
  Future<void> updateUsername(String username) async{
    User user = await _userRepository.getUser();

    return await user.updateProfile(displayName: username);
  }

  @override
  Future<Profile> addNewProfile() async {
    User user = await _userRepository.getUser();

    Profile newProfile = Profile(user.email, new List<String>(), displayName: user.displayName, isEmailVerified: user.emailVerified);
    await usersCollection.doc(user.uid).set(newProfile.toEntity().toDocument());

    return await getCurrentProfile();
  }

}