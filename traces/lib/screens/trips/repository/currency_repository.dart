import 'package:traces/screens/trips/model/api_models/currency.model.dart';
import 'package:traces/screens/trips/model/api_models/currency_rate.model.dart';
import 'package:traces/utils/services/api_service.dart';
import 'package:traces/utils/services/currency_service.dart';

class CurrencyRepository{
  CurrencyService currencyService = CurrencyService();
  ApiService apiProvider = ApiService();
  String tripsUrl = 'currencies/';

  Future<List<Currency>?> getCurrencies() async{    
    print("getCurrencies");
    final response = await apiProvider.getSecure(tripsUrl);
      
    var currResponse = response["currencies"] != null ? 
      response['currencies'].map<Currency>((map) => Currency.fromMap(map)).toList() : null;
    return currResponse;
  }

  Future<CurrencyRateModel> convert(String currencyFrom, String currencyTo, double amount) async{
    final response = await currencyService.convert(currencyFrom, currencyTo, amount);
    var currencyRate = CurrencyRateModel.fromMap(response);

    return currencyRate;
  }

  Future<CurrencyRateModel> getCurrencyRateAmountForDate(String currencyFrom, String currencyTo, double amount, DateTime date) async{
    final response = await currencyService.convertForDate(currencyFrom, currencyTo, amount, date);
    var currencyRate = CurrencyRateModel.fromMap(response);

    return currencyRate;
  }
}