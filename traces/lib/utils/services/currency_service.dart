import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:traces/utils/api/customException.dart';

class CurrencyService{
  static String _baseUrl = "https://api.getgeoapi.com/v2/currency/";
  static String? _apiKey;

  CurrencyService(){
    _apiKey = dotenv.env['GETGEOAPIKEY'];
  }

  Future<dynamic> convert(String currencyFrom, String currencyTo, double amount) async{    
    
    final queryParameters = {
      'api_key': _apiKey,
      'from': currencyFrom,
      'to': currencyTo,
      'amount': amount.toStringAsFixed(2)
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    
    Uri uri = Uri.parse("${_baseUrl}convert" + '?' + queryString);   

    var response = await http.get(uri);    
    
    Map<String, dynamic>? data = json.decode(response.body.toString());

    if(data?["status"] == "success") return data;
    else return BadRequestException("Error using getgeoapi. Currency Rates not loaded");
    
  }

  Future<dynamic> convertForDate(String currencyFrom, String currencyTo, double amount, DateTime date) async{    

    var dateParam = DateFormat('yyyy-MM-dd').format(date);
    
    final queryParameters = {
      'api_key': _apiKey,
      'from': currencyFrom,
      'to': currencyTo,
      'amount': amount.toStringAsFixed(2)
    };

    String queryString = Uri(queryParameters: queryParameters).query;
    
    Uri uri = Uri.parse("${_baseUrl}historical/$dateParam" + '?' + queryString);   

    var response = await http.get(uri);    
    
    Map<String, dynamic>? data = json.decode(response.body.toString());

    if(data?["status"] == "success") return data;
    else return BadRequestException("Error using getgeoapi. Currency Rates not loaded");
    
  }
}