import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/services/secure_storage_service.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApiService {
  static ApiService? _instance;
  static String _baseUrl = "http://10.0.2.2:8080/"; //emulator
  //static String _baseUrl = "http://192.168.7.109:8080/"; // local IP
  //static String _baseUrl = "http://192.168.7.200:3002/"; // Local NAS
  //static String _baseUrl = "http://178.124.197.224:3002/"; // External NAS
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
    if (refreshToken == null) throw UnauthorizedException();
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
      throw ConnectionException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> sendOtpToEmail(String url, String body) async{
    var responseJson;
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json"      
    };

    try{
      responseJson = await  sendPost(uri, headers, body);
      var verificationKey = responseJson["verificationKey"];
      await _storage!.write(key: "verificationKey", value: verificationKey);

    }on SocketException catch(e) {
      throw ConnectionException(e.message);
    }
    
    return responseJson;
  }

  Future<dynamic> verifyOtp(String url, String body) async{
    var responseJson;
    Uri uri = Uri.parse(_baseUrl + url);

    var verificationKey = await _storage!.read(key: "verificationKey");
    if(verificationKey == null) throw "Verification key not found";
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "verification-key": verificationKey,
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }
    
    return responseJson;
  }
  
  Future<dynamic> signOut() async{
    print("signOut");
    var responseJson;

    Uri uri = Uri.parse(_baseUrl + 'auth/revoke-token');

    var token = await _storage!.read(key: "refresh_token");
    if (token == null) throw UnauthorizedException();
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
      //await _storage!.delete(key: "refresh_token"); 
      responseJson = await sendPost(uri, headers, json.encode(body));      

      var res = responseJson;

    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException catch(e) {
      await refreshToken();
      
      headers["authorization"] = "Bearer $_accessToken";

      token = await _storage!.read(key: "refresh_token");
      if (token == null) throw UnauthorizedException();
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
      throw ConnectionException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getSecure(String url, {Map<String, dynamic>? queryParams}) async{
    print("getSecure");
    var responseJson;

    String queryString = Uri(queryParameters: queryParams).query;
    
    Uri uri = Uri.parse(_baseUrl + url + '?' + queryString);
    Map<String, String> headers = {      
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{      
      responseJson = await sendGet(uri, headers);
    }on SocketException {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException {
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
      throw ConnectionException('No Internet connection');
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
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException catch(e) {
      await refreshToken();
     
      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendPost(uri, headers, body);      
    }
    return responseJson;  
  }

  Future<dynamic> postSecureMultipart(String url, String? body, File? file) async{
    print("postSecure");
    var responseJson;    
    
    var request = http.MultipartRequest("POST", Uri.parse(_baseUrl + url));

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["Authorization"] = "Bearer $_accessToken";
    request.headers["device-info"] = _deviceId ?? '';

    if(file != null){
      request.files.add(http.MultipartFile.fromBytes("file", file.readAsBytesSync(), filename: file.path));
    }
    
    try{
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await  _response(response);      
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException catch(e) {
      await refreshToken();
     
      request.headers["Authorization"] = "Bearer $_accessToken";
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await  _response(response);       
    }
    return responseJson;  
  }

  Future<dynamic> putSecure(String url, String body) async{
    print("putSecure");
    var responseJson;
    
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPut(uri, headers, body);      
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException catch(e) {
      await refreshToken();
      
      headers["authorization"] = "Bearer $_accessToken";
      
      responseJson = await sendPut(uri, headers, body);      
    }
    return responseJson;  
  }

  Future<dynamic> deleteSecure(String url) async{
    print("deleteSecure");
    var responseJson;
   
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {      
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{      
      responseJson = await sendDelete(uri, headers);
    }on SocketException {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException {
      await refreshToken();
      
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
      _accessToken = refreshToken;
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
        throw BadRequestException(errorMessage);
      case 401:
        throw UnauthorizedException(errorMessage); 
      case 403:
        throw ForbiddenException(errorMessage);      
      default:
        throw CustomException(Error.Default, 
            'Server Error. StatusCode: ${response.statusCode}. Error: $errorMessage');
    }
  }  

}