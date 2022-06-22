import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CurrencyRateModel {
  final String currencyFrom;
  final String currencyTo;
  final double rate;
  final DateTime date;
  
  CurrencyRateModel({
    required this.currencyFrom,
    required this.currencyTo,
    required this.rate,
    required this.date,
  });
  
  CurrencyRateModel copyWith({
    String? currencyFrom,
    String? currencyTo,
    double? rate,
    DateTime? date,
  }) {
    return CurrencyRateModel(
      currencyFrom: currencyFrom ?? this.currencyFrom,
      currencyTo: currencyTo ?? this.currencyTo,
      rate: rate ?? this.rate,
      date: date ?? this.date,
    );
  } 

  factory CurrencyRateModel.fromMap(Map<String, dynamic> map) {
    Map m = map['rates'][0];
    var keys = m.keys;
    var mKey = m.keys.first();

    print('123');
    return CurrencyRateModel(
      currencyFrom: map['base_currency_code'] as String,
      currencyTo: (map['rates'][0] as Map).keys.first() as String,
      rate: map['rates'][0]["rate"] as double,
      date: DateTime.fromMillisecondsSinceEpoch(map['Date'] as int),
    );
  }
  

  factory CurrencyRateModel.fromJson(String source) => CurrencyRateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CurrencyRateModel(CurrencyFrom: $currencyFrom, CurrencyTo: $currencyTo, Rate: $rate, Date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is CurrencyRateModel &&
      other.currencyFrom == currencyFrom &&
      other.currencyTo == currencyTo &&
      other.rate == rate &&
      other.date == date;
  }

  @override
  int get hashCode {
    return currencyFrom.hashCode ^
      currencyTo.hashCode ^
      rate.hashCode ^
      date.hashCode;
  }
}
