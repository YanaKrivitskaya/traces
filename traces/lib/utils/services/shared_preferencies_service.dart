import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService{
  static SharedPreferencesService? _instance;
  static SharedPreferences? _storage;

    SharedPreferencesService._internal() {
    _instance = this;
  }

  factory SharedPreferencesService() => _instance ?? SharedPreferencesService._internal();

  static Future<dynamic> init() async{
    _storage = await SharedPreferences.getInstance(); 
  }

  String? read({required String key}){
    return _storage!.getString(key);
  }

  Future<void> write({required String key, required String value}){
    return _storage!.setString(key, value);
  }
}