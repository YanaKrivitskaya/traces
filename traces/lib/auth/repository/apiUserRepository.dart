import 'package:traces/auth/model/user.dart';
import 'package:traces/helpers/api.provider.dart';

class ApiUserRepository{
  ApiProvider apiProvider = ApiProvider();
  String authUrl = 'auth/';

  Future<void> signUp(User user) async{
    final response = await apiProvider.post(authUrl + 'register', user.toJson());
    return response;
  }
}