
import 'package:traces/screens/profile/model/member.dart';
import 'package:traces/screens/profile/model/profile.dart';

abstract class ProfileRepository {

  Future<Profile> addNewProfile();

  Future<Profile> updateProfile(Profile profile);

  Future<Profile> getCurrentProfile();

  Future<void> updateUsername(String username);

  Stream<List<Member>> familyMembers();

  Future<void> addNewMember(Member member);

  Future<void> updateMember(Member member);

  Future<Member> getMemberById(String? id);
}