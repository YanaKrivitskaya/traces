import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CurrencyRateModel {
  final String currencyFrom;
  final String currencyTo;
  final double rateAmount;
  final DateTime date;
  
  CurrencyRateModel({
    required this.currencyFrom,
    required this.currencyTo,
    required this.rateAmount,
    required this.date,
  });
  
  CurrencyRateModel copyWith({
    String? currencyFrom,
    String? currencyTo,
    double? rateAmount,
    DateTime? date,
  }) {
    return CurrencyRateModel(
      currencyFrom: currencyFrom ?? this.currencyFrom,
      currencyTo: currencyTo ?? this.currencyTo,
      rateAmount: rateAmount ?? this.rateAmount,
      date: date ?? this.date,
    );
  } 

  factory CurrencyRateModel.fromMap(Map<String, dynamic> map) {
    Map m = map['rates'];
    
    return CurrencyRateModel(
      currencyFrom: map['base_currency_code'] as String,
      currencyTo: m.keys.first as String,
      rateAmount: double.parse(m[m.keys.first]["rate_for_amount"]),
      date: DateTime.parse(map['updated_date']),
    );
  }
  

  factory CurrencyRateModel.fromJson(String source) => CurrencyRateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurrencyRateModel(CurrencyFrom: $currencyFrom, CurrencyTo: $currencyTo, rateAmount: $rateAmount, Date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CurrencyRateModel &&
      other.currencyFrom == currencyFrom &&
      other.currencyTo == currencyTo &&
      other.rateAmount == rateAmount &&
      other.date == date;
  }

  @override
  int get hashCode {
    return currencyFrom.hashCode ^
      currencyTo.hashCode ^
      rateAmount.hashCode ^
      date.hashCode;
  }
}
