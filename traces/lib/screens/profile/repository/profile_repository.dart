
import 'package:traces/screens/profile/model/family.dart';
import 'package:traces/screens/profile/model/profile.dart';

abstract class ProfileRepository {
  Stream<List<Family>> familyMembers();

  Future<Profile> addNewProfile();

  Future<Profile> updateProfile(Profile profile);

  Future<Family> addNewFamilyMember(Family family);

  Future<Family> updateFamilyMember(Family family);

  Future<void> deleteFamilyMember(Family family);

  Future<Profile> getCurrentProfile();

  Future<Family> getFamilyById(String id);

  Future<void> updateUsername(String username);
}