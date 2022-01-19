import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:traces/utils/api/customException.dart';

class ApiProvider{
  final String _baseUrl = "http://192.168.7.200:3002/";
  //final String _baseUrl = "http://10.0.2.2:8080/";
  final _storage = FlutterSecureStorage();

  Future<dynamic> get(String url) async{
    var responseJson;
    Uri uri = Uri.parse(_baseUrl + url);

    try{
      responseJson = await sendGet(uri, null);
    }on SocketException {
      throw ConnectionException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getSecure(String url) async{
    var responseJson;

    var accessToken = await _storage.read(key: "access_token");
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {      
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try{      
      responseJson = await sendGet(uri, headers);
    }on SocketException {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException {
      await refreshToken();

      var accessToken = await _storage.read(key: "access_token");
      headers["authorization"] = "Bearer $accessToken";
      
      responseJson = await sendGet(uri, headers);      
    }

    return responseJson;
  }

  Future<dynamic> post(String url, String body) async{
    var responseJson;
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json"      
    };

    try{
      responseJson = await  sendPost(uri, headers, body);      
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }
    
    return responseJson;
  }

  Future<dynamic> postSecure(String url, String body) async{
    var responseJson;

    var accessToken = await _storage.read(key: "access_token");
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };

    try{
      responseJson = await sendPost(uri, headers, body);      
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }on UnauthorizedException catch(e) {
      await refreshToken();

      var accessToken = await _storage.read(key: "access_token");
      headers["authorization"] = "Bearer $accessToken";
      
      responseJson = await sendPost(uri, headers, body);      
    }

    return responseJson;  
  }

  Future<dynamic> sendGet(Uri uri, Map<String, String>? headers) async{
    var response = await http.get(uri, headers: headers);
    return await _response(response);     
  }

  Future<dynamic> sendPost(Uri uri, Map<String, String> headers, String body) async{
    var response = await http.post(uri, headers: headers, body: body);
    return await _response(response); 
  }

  Future<dynamic> refreshToken() async{
    var responseJson;

    var refreshToken = await _storage.read(key: "refresh_token");
    if (refreshToken == null) throw UnauthorizedException();
    var body = {
      "token": refreshToken
    };

    try{
      final response = await http.post(
        Uri.parse(_baseUrl + 'auth/refresh-token'), 
        headers: {          
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        },
        body: body
      );
      responseJson = await _response(response);
      var accessToken = responseJson["accessToken"];
      _storage.write(key: "access_token", value: accessToken);

    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) async{
    if(response.headers["set-cookie"] != null){      
      var refreshToken = response.headers["set-cookie"].toString().split(';')[0].substring(13);
      await _storage.write(key: "refresh_token", value: refreshToken);      
    }
    var errorMessage;

    if(response.statusCode != 200){
      errorMessage = jsonDecode(response.body.toString())["message"];
    }
        
    switch(response.statusCode){
      case 200: {
        Map<String, dynamic> data = json.decode(response.body.toString());
        return data;
      }      
      case 400:
        throw BadRequestException(errorMessage);
      case 401:
        throw UnauthorizedException(errorMessage);
      case 403:
        throw ForbiddenException(errorMessage);   
      default:
        throw FetchDataException(errorMessage);
    }
  }
}