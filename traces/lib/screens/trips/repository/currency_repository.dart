import 'package:traces/screens/trips/model/api_models/currency_rate.model.dart';
import 'package:traces/utils/services/currency_service.dart';

class CurrencyRepository{
  CurrencyService currencyService = CurrencyService();

  Future<CurrencyRateModel> convertToUSD(String currencyFrom, double amount) async{
    final response = await currencyService.convertToUSD(currencyFrom, amount);
    var currencyRate = CurrencyRateModel.fromMap(response);

    return currencyRate;
  }

  Future<CurrencyRateModel> getCurrencyRateAmountForDate(String currencyFrom, double amount, DateTime date) async{
    final response = await currencyService.convertForDate(currencyFrom, amount, date);
    var currencyRate = CurrencyRateModel.fromMap(response);

    return currencyRate;
  }
}