import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/model/member_entity.dart';

import '../../../auth/firebaseUserRepository.dart';
import '../model/profile.dart';
import '../model/profile_entity.dart';
import 'profile_repository.dart';


class FirebaseProfileRepository extends ProfileRepository{
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final String userFamily = "family";

  FirebaseUserRepository _userRepository;

  FirebaseProfileRepository() {
    _userRepository = new FirebaseUserRepository();
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

    Profile newProfile = Profile(user.email, displayName: user.displayName, isEmailVerified: user.emailVerified);
    await usersCollection.doc(user.uid).set(newProfile.toEntity().toDocument());

    Member newMember = Member(name: user.displayName);
    await addNewMember(newMember);

    return await getCurrentProfile();
  }

  @override
  Stream<List<Member>> familyMembers() async* {
    String uid = await _userRepository.getUserId();

    yield* usersCollection.doc(uid).collection(userFamily).snapshots()
      .map((snap){
        return snap.docs
          .map((doc) => Member.fromEntity(MemberEntity.fromSnapshot(doc)))
          .toList();
      });    
  }

  @override
  Future<void> addNewMember(Member member) async {
    String uid = await _userRepository.getUserId();
    
    await usersCollection.doc(uid).collection(userFamily)
      .add(member.toEntity().toDocument());    
  }

  @override
  Future<void> updateMember(Member member) async {
    String uid = await _userRepository.getUserId();
    
    await usersCollection.doc(uid).collection(userFamily).doc(member.id)
      .update(member.toEntity().toDocument());
  }

  @override
  Future<Member> getMemberById(String id) async {
    String uid = await _userRepository.getUserId();
    
    var member = await usersCollection.doc(uid).collection(userFamily).doc(id).get();

    return Member.fromEntity(MemberEntity.fromMap(member.data()));
  }
}
