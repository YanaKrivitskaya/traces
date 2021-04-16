import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettingsEntity extends Equatable{
  final List<String> themes;

  AppSettingsEntity(this.themes);

  @override
  List<Object> get props => [themes];

  static AppSettingsEntity fromMap(Map<dynamic, dynamic> map){
    return AppSettingsEntity(
      map["themes"].cast<String>() as List<String>
    );
  }

  static AppSettingsEntity fromSnapshot(DocumentSnapshot snap){
    return AppSettingsEntity(snap["themes"]);
  }

  Map<String, Object> toDocument(){
    return {
      "themes": themes
    };
  }
}

  @immutable class AppSettings{
  final List<String> themes;

  AppSettings(this.themes);

  AppSettings copyWith({List<String> themes}){
    return AppSettings(      
      themes ?? this.themes
    );
  }

  AppSettingsEntity toEntity(){
    return AppSettingsEntity(themes);
  }

  static AppSettings fromEntity(AppSettingsEntity entity){
    return AppSettings(
      entity.themes
    );
  }
}