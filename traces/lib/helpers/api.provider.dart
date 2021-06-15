import 'package:http/http.dart' as http;
import 'customException.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ApiProvider{
  //final String _baseUrl = "http://192.168.7.200:3002/";
  final String _baseUrl = "http://10.0.2.2:8080/";

  Future<dynamic> get(String url) async{
    var responseJson;

    try{
      final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _response(response);      
    }on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, String body) async{
    var responseJson;

    try{
      final response = await http.post(Uri.parse(_baseUrl + url), 
        body: body
      );
      responseJson = _response(response);      
    }on SocketException catch(e) {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response){
    switch(response.statusCode){
      case 200:        
        return json.decode(response.body.toString());
      case 400:
        throw BadRequestException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }

  }


}