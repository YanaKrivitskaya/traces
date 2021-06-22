
import 'dart:convert';
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/services/api_service.dart';
import 'package:traces/utils/services/secure_storage_service.dart';
import '../model/login.model.dart';
import '../model/user.model.dart';
import 'userRepository.dart';


class ApiUserRepository extends UserRepository{
  
  ApiService apiProvider = ApiService();
  String authUrl = 'auth/';
  final _storage = SecureStorage();

  @override
  Future<void> signUp(User user) async{
    final response = await apiProvider.post(authUrl + 'register', user.toJson());
    return response;
  }

  @override
  Future<User> signInWithEmailAndPassword(LoginModel loginModel) async {        
    try{
      final response = await apiProvider.post(authUrl + 'login', loginModel.toJson());
      var user = User.fromMap(response["user"]);
      var accessToken = response["accessToken"];
      await _storage.write(key: "access_token", value: accessToken);
      return user;
    } on Exception catch(e){      
      throw(e);
    }    
  }

  @override
  Future<User> getAccessToken() async {
   
    final response = await apiProvider.refreshToken();
    var user = User.fromMap(response["user"]);    

    return user;
  }

  @override
  Future<User> getUser(int userId) async{    
    var userIdParam = userId.toString();
    final response = await apiProvider.getSecure(authUrl + '/users/$userIdParam');
    return User.fromMap(response);
  }
  

  @override
  Future<String> getUserId() {
    // TODO: implement getUserId
    throw UnimplementedError();
  }  

  @override
  Future<void> signOut() async {
    var refreshToken = await _storage.read(key: "refresh_token");
    if (refreshToken == null) throw UnauthorisedException();
    var body = {
      "token": refreshToken
    };
    await apiProvider.postSecure(authUrl + 'revoke-token', json.encode(body));
  }

  @override
  Future<User> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }
}