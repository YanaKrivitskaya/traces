import '../../utils/services/api_service.dart';
import '../model/login.model.dart';
import '../model/user.model.dart';
import 'userRepository.dart';


class ApiUserRepository extends UserRepository{
  
  ApiService apiProvider = ApiService();
  String authUrl = 'auth/'; 

  @override
  Future<void> signUp(User user) async{
    print("signUp");
    final response = await apiProvider.post(authUrl + 'register', user.toJson());
    return response;
  }

  @override
  Future<User> signInWithEmailAndPassword(LoginModel loginModel) async {   
    print("signIn");     
    try{      
      final response = await apiProvider.post(authUrl + 'login', loginModel.toJson());
      var user = User.fromMap(response["user"]);      
      return user;
    } on Exception catch(e){      
      throw(e);
    }    
  }

  @override
  Future<User> getAccessToken() async {
    print("getAccessToken");    
   
    final response = await apiProvider.refreshToken();
    var user = User.fromMap(response["user"]);    

    return user;
  }

  @override
  Future<User> getUser(int userId) async{
    print("getUser");
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
    print("signOut");    
    
    await apiProvider.signOut();
  }

  @override
  Future<User> isSignedIn() {
    // TODO: implement isSignedIn
    throw UnimplementedError();
  }
}