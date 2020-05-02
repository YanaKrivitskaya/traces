import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async{

    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String username) async{
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    UserUpdateInfo profileUpdate = UserUpdateInfo();
    profileUpdate.displayName = username;
    return await user.updateProfile(profileUpdate);
  }

  Future<void> signOut() async{
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> getUserId() async{
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<bool> isSignedIn() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null;
  }

}