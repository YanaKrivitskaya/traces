
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/profile.dart';

abstract class ProfileRepository {
  Stream<List<Family>> familyMembers();

  Future<List<Family>> getFamilyMembers();

  Future<Profile> addNewProfile();

  Future<Profile> updateProfile(Profile profile);

  Future<void> addNewFamilyMember(Family family);

  Future<void> updateFamilyMember(Family family);

  Future<void> deleteFamilyMember(Family family);

  Future<Profile> getCurrentProfile();

  Future<Family> getFamilyById(String id);

  Future<void> updateUsername(String username);
}