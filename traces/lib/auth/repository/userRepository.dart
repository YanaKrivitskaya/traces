import 'dart:async';

import '../model/login.model.dart';
import '../model/account.model.dart';

abstract class UserRepository{

  Future<Account> verifyOtp(String otp, String email);
  
  Future<void> signInWithEmail(String email);

  Future<Account> signInWithEmailAndPassword(LoginModel loginModel); 

  Future<Account> getAccessToken();

  Future<void> signOut();

  Future<String> getUserId();

  Future<Account> getUser(int userId);

  Future<Account> isSignedIn();

  Future<Account> updateEmail(String email);
}