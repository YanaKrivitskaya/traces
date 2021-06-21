import 'dart:async';

import '../model/login.model.dart';
import '../model/user.model.dart';

abstract class UserRepository{
  Future<User> signInWithEmailAndPassword(LoginModel loginModel);

  Future<void> signUp(User user);

  Future<User> getAccessToken();

  Future<void> signOut();

  Future<String> getUserId();

  Future<User> getUser(int userId);

  Future<User> isSignedIn();
}