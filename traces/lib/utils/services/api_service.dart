import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/services/secure_storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiService {
  static ApiService? _instance;
  static String _baseUrl = "http://10.0.2.2:8080/";
  static SecureStorage? _storage;
  static String? _accessToken;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static String? _deviceId;
    
  ApiService._internal() {
    _storage = SecureStorage();    
    _instance = this;
  }

  factory ApiService() => _instance ?? ApiService._internal();

  static Future<dynamic> init() async{
    if(Platform.isAndroid){
      await deviceInfoPlugin.androidInfo.then((data) => _deviceId = data.androidId);
    }else if (Platform.isIOS) {
      await deviceInfoPlugin.iosInfo.then((data) => _deviceId = data.identifierForVendor);
    }
  }

  Future<dynamic> refreshToken() async{
    print("refreshToken");
    var responseJson;

    var refreshToken = await _storage!.read(key: "refresh_token");
    if (refreshToken == null) throw UnauthorisedException();
    var body = {
      "token": refreshToken,
      "device": _deviceId
    };

    try{
      final response = await http.post(
        Uri.parse(_baseUrl + 'auth/refresh-token'), 
        headers: {          
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          "Device-info": _deviceId ?? ''
        },
        body: body
      );
      responseJson = await _response(response);
      _accessToken = responseJson["accessToken"];     

    }on SocketException catch(e) {
      throw CustomException('No Internet connection');
    }
    return responseJson;
  }
  
  Future<dynamic> signOut() async{
    print("signOut");
    var responseJson;

    Uri uri = Uri.parse(_baseUrl + 'auth/revoke-token');

    var token = await _storage!.read(key: "refresh_token");
    if (token == null) throw UnauthorisedException();
    var body = {
      "token": token,
      "device": _deviceId
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, json.encode(body));      

    }on SocketException catch(e) {
      throw CustomException('No Internet connection');
    }on UnauthorisedException catch(e) {
      await refreshToken();
      
      headers["authorization"] = "Bearer $_accessToken";

      token = await _storage!.read(key: "refresh_token");
      if (token == null) throw UnauthorisedException();
      body = {
        "token": token
      };
      
      responseJson = await sendPost(uri, headers, json.encode(body));      
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async{
    print("get");
    var responseJson;
    Uri uri = Uri.parse(_baseUrl + url);

    try{
      responseJson = await sendGet(uri, null);
    }on SocketException {
      throw CustomException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getSecure(String url) async{
    print("getSecure");
    var responseJson;

    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {      
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{      
      responseJson = await sendGet(uri, headers);
    }on SocketException {
      throw CustomException('No Internet connection');
    }on UnauthorisedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendGet(uri, headers);      
    }

    return responseJson;
  }

  Future<dynamic> post(String url, String body) async{
    print("post");
    var responseJson;    
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);
      _accessToken = responseJson["accessToken"] ?? _accessToken;
    }on SocketException catch(e) {
      throw CustomException('No Internet connection');
    }
    
    return responseJson;
  }

  Future<dynamic> postSecure(String url, String? body) async{
    print("postSecure");
    var responseJson;
    
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);      
    }on SocketException catch(e) {
      throw CustomException('No Internet connection');
    }on UnauthorisedException catch(e) {
      await refreshToken();

      //var accessToken = await _storage!.read(key: "access_token");
      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendPost(uri, headers, body);      
    }
    return responseJson;  
  }

  Future<dynamic> putSecure(String url, String body) async{
    print("putSecure");
    var responseJson;

    //var accessToken = await _storage!.read(key: "access_token");
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPut(uri, headers, body);      
    }on SocketException catch(e) {
      throw CustomException('No Internet connection');
    }on UnauthorisedException catch(e) {
      await refreshToken();

      //var accessToken = await _storage!.read(key: "access_token");
      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendPut(uri, headers, body);      
    }
    return responseJson;  
  }

  Future<dynamic> deleteSecure(String url) async{
    print("deleteSecure");
    var responseJson;

    //var accessToken = await _storage!.read(key: "access_token");
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {      
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{      
      responseJson = await sendDelete(uri, headers);
    }on SocketException {
      throw CustomException('No Internet connection');
    }on UnauthorisedException {
      await refreshToken();

      //var accessToken = await _storage!.read(key: "access_token");
      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendDelete(uri, headers);      
    }
    return responseJson;
  }

  Future<dynamic> sendGet(Uri uri, Map<String, String>? headers) async{
    var response = await http.get(uri, headers: headers);
    return await _response(response);     
  }

  Future<dynamic> sendPost(Uri uri, Map<String, String> headers, String? body) async{
    var response = await http.post(uri, headers: headers, body: body);
    return await _response(response); 
  }

  Future<dynamic> sendPut(Uri uri, Map<String, String> headers, String body) async{
    var response = await http.put(uri, headers: headers, body: body);
    return await _response(response); 
  }

  Future<dynamic> sendDelete(Uri uri, Map<String, String> headers) async{
    var response = await http.delete(uri, headers: headers);
    return await _response(response);     
  }
  
  dynamic _response(http.Response response) async{
    if(response.headers["set-cookie"] != null){      
      var refreshToken = response.headers["set-cookie"].toString().split(';')[0].substring(13);
      await _storage!.write(key: "refresh_token", value: refreshToken);      
    }
    var errorMessage;

    if(response.statusCode != 200){
      errorMessage = jsonDecode(response.body.toString())["message"];
    }
        
    switch(response.statusCode){
      case 200: {
        Map<String, dynamic>? data = json.decode(response.body.toString());
        return data;
      }      
      case 400:
        throw CustomException("Invalid Request: $errorMessage");
      case 401:
        throw UnauthorisedException(errorMessage); 
      case 403:
        throw ForbiddenException(errorMessage);      
      default:
        throw CustomException(
            'Server Error. StatusCode: ${response.statusCode}. Error: ${errorMessage}');
    }
  }  
}