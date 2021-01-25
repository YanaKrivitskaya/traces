import 'package:firebase_auth/firebase_auth.dart';

class UserRepository{
  final FirebaseAuth _firebaseAuth;

  UserRepository({FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithEmailAndPassword(String email, String password) async{

    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password, String username) async{
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;

    return await user.updateProfile(displayName: username);
  }

  Future<void> signOut() async{
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<String> getUserId() async{
    return (_firebaseAuth.currentUser).uid;
  }

  Future<User> getUser() async{
    return (_firebaseAuth.currentUser);
  }

  Future<bool> isSignedIn() async{
    User user = _firebaseAuth.currentUser;
    return user != null;
  }

}