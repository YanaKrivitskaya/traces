import 'package:traces/auth/model/login.model.dart';

import 'package:traces/auth/model/account.model.dart';

import 'userRepository.dart';

class MockUserRepository extends UserRepository{

  @override
  Future<void> signInWithEmail(String email) async {    
    print("MockUserRepository.signInWithEmail");
  }

  @override
  Future<Account> verifyOtp(String otp, String email) async{
    print("MockUserRepository.verifyOtp");
    return _getTestUser();
  }

  @override
  Future<Account> getAccessToken() async{
    print("MockUserRepository.getAccessToken");
    return _getTestUser(); 
  }

  @override
  Future<Account> getUser(int userId) async{
    print("MockUserRepository.getUser");
    return _getTestUser();
  }

  @override
  Future<String> getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }

  @override
  Future<Account> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }

  @override
  Future<Account> signInWithEmailAndPassword(LoginModel loginModel) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Account> updateEmail(String email) {
    // TODO: implement updateEmail
    throw UnimplementedError();
  }

  Account _getTestUser(){
    var user = new Account(
      id: 1,
      name: "testUser",
      email: "test.user@traces.com"
    );
    return user;
  }
}