import '../../utils/services/api_service.dart';
import '../model/login.model.dart';
import '../model/account.model.dart';
import 'userRepository.dart';
import 'dart:convert';


class ApiUserRepository extends UserRepository{
  
  ApiService apiProvider = ApiService();
  String authUrl = 'auth/';

  Future<void> signInWithEmail(String email) async {   
    var body = {
      "email": email      
    };   
    try{
      await apiProvider.sendOtpToEmail(authUrl + 'verify-email', json.encode(body));
      //var user = Account.fromMap(response["account"]);      
    } on Exception catch(e){      
      throw(e);
    }    
  }

  Future<Account> verifyOtp(String otp, String email) async {   
    var body = {
      "email": email,
      "otp": otp
    };   
    try{
      var response = await apiProvider.verifyOtp(authUrl + 'login', json.encode(body));
      var user = Account.fromMap(response["account"]);
      return user;
    } on Exception catch(e){      
      throw(e);
    }    
  }

  @override
  Future<Account> getAccessToken() async {
    print("getAccessToken");    
   
    final response = await apiProvider.refreshToken();
    var user = Account.fromMap(response["account"]);    

    return user;
  }

  @override
  Future<Account> getUser(int userId) async{
    print("getUser");
    var userIdParam = userId.toString();
    final response = await apiProvider.getSecure(authUrl + '/users/$userIdParam');
    return Account.fromMap(response);
  }

  @override
  Future<Account> updateEmail(String email) async{
    print("updateEmail");
    var body = {
      "email": email      
    };
    final response = await apiProvider.putSecure(authUrl + 'email', json.encode(body));
   
    return Account.fromMap(response["account"]);
  }
  

  @override
  Future<String> getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }  

  @override
  Future<void> signOut() async {
    print("signOut");    
    
    await apiProvider.signOut();
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
}