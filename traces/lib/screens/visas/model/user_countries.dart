import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';

class UserSettingsEntity extends Equatable{
  final List<String>? countries;
  final List<String>? cities;

  UserSettingsEntity(this.countries, this.cities);

  @override
  List<Object?> get props => [countries, cities];

  Map<String, Object?> toJson(){
    return{
      "countries": countries,
      "cities": cities
    };
  }

  static UserSettingsEntity fromMap(Map<dynamic, dynamic> map){    
    return UserSettingsEntity(
        map != null && map["countries"] != null ? map["countries"].cast<String>() as List<String>? : <String>[],
        map != null && map["cities"] != null ? map["cities"].cast<String>() as List<String>? : <String>[]
    );   
  }

  static UserSettingsEntity fromSnapshot(DocumentSnapshot snap){
    return UserSettingsEntity(
        snap['countries'].cast<String>(),
        snap['cities'].cast<String>()
    );
  }

  Map<String, Object?> toDocument(){
    return{
      "countries": countries,
      "cities": cities,
    };
  }
}

@immutable
class UserSettings{
  final List<String>? countries;
  final List<String>? cities;

  UserSettings(this.countries, this.cities);

  UserSettingsEntity toEntity(){
    return UserSettingsEntity(countries, cities);
  }

  static UserSettings fromEntity(UserSettingsEntity entity){
    return UserSettings(
        entity.countries,
        entity.cities
    );
  }
}