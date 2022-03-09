import '../../utils/services/api_service.dart';
import '../model/login.model.dart';
import '../model/account.model.dart';
import 'userRepository.dart';
import 'dart:convert';


class ApiUserRepository extends UserRepository{
  
  ApiService apiProvider = ApiService();
  String authUrl = 'auth/'; 

  @override
  Future<void> signUp(Account user) async{
    print("signUp");
    final response = await apiProvider.post(authUrl + 'register', user.toJson());
    return response;
  }

  @override
  Future<Account> signInWithEmailAndPassword(LoginModel loginModel) async {   
    print("signIn");     
    try{      
      final response = await apiProvider.post(authUrl + 'login', loginModel.toJson());
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
}