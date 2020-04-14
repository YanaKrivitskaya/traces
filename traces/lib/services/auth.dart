
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> login(String email, String password);

  Future<String> register(String email, String password, String username);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> logout();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async{

    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  Future<String> register(String email, String password, String username) async{
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    FirebaseUser user = result.user;

    UserUpdateInfo profileUpdate = UserUpdateInfo();
    profileUpdate.displayName = username;
    await user.updateProfile(profileUpdate);
    return user.uid;

  }

  Future<FirebaseUser> getCurrentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> sendEmailVerification() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<void> logout() async{
    return _firebaseAuth.signOut();
  }

  Future<bool> isEmailVerified() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

}