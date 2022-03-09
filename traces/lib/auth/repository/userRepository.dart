import 'dart:async';

import '../model/login.model.dart';
import '../model/account.model.dart';

abstract class UserRepository{
  Future<Account> signInWithEmailAndPassword(LoginModel loginModel);

  Future<void> signUp(Account user);

  Future<Account> getAccessToken();

  Future<void> signOut();

  Future<String> getUserId();

  Future<Account> getUser(int userId);

  Future<Account> isSignedIn();

  Future<Account> updateEmail(String email);
}