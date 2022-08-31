import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? _instance;
  static FlutterSecureStorage? _storage;

  SecureStorage._internal() {
    _storage = FlutterSecureStorage();
    _instance = this;
  }

  Future<String?> read({required String key}){
    return _storage!.read(key: key);
  }

  Future<void> write({required String key, required String value}){
    return _storage!.write(key: key, value: value);
  }

  Future<void> delete({required String key}){
    return _storage!.delete(key: key);
  }

  factory SecureStorage() => _instance ?? SecureStorage._internal();
}