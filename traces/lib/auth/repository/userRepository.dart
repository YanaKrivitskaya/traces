import 'dart:async';
import 'package:traces/auth/model/user.dart';

abstract class UserRepository{
  Future<void> signInWithEmailAndPassword(String email, String password);

  Future<void> signUp(User user);

  Future<void> signOut();

  Future<String> getUserId();

  Future<User> getUser();

  Future<bool> isSignedIn();
}