
import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/user_countries_entity.dart';

@immutable
class UserCountries{
  final List<String> countries;

  UserCountries(this.countries);

  UserCountriesEntity toEntity(){
    return UserCountriesEntity(countries);
  }

  static UserCountries fromEntity(UserCountriesEntity entity){
    return UserCountries(
        entity.countries
    );
  }

}