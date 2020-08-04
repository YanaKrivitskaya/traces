
import 'package:traces/screens/profile/model/profile.dart';

abstract class ProfileRepository {

  Future<Profile> addNewProfile();

  Future<Profile> updateProfile(Profile profile);

  Future<Profile> getCurrentProfile();

  Future<void> updateUsername(String username);
}