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

  String? readString({required String key}){
    return _storage!.getString(key);
  }

  Future<void> writeString({required String key, required String value}){
    return _storage!.setString(key, value);
  }

  int? readInt({required String key}){
    return _storage!.getInt(key);
  }

  Future<void> writeInt({required String key, required int value}){
    return _storage!.setInt(key, value);
  }

  void remove({required String key}){
    _storage!.remove(key);
  }
}