import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppUserSettingsEntity extends Equatable{
  final String theme;

  AppUserSettingsEntity(this.theme);

  @override
  List<Object> get props => [theme];

  static AppUserSettingsEntity fromMap(Map<dynamic, dynamic> map){
    return AppUserSettingsEntity(
      map["theme"] as String
    );
  }

  static AppUserSettingsEntity fromSnapshot(DocumentSnapshot snap){
    return AppUserSettingsEntity(snap["theme"]);
  }

  Map<String, Object> toDocument(){
    return {
      "theme": theme
    };
  }
}

  @immutable class AppUserSettings{
  final String theme;

  AppUserSettings(this.theme);

  AppUserSettings copyWith({String theme}){
    return AppUserSettings(      
      theme ?? this.theme
    );
  }

  AppUserSettings toEntity(){
    return AppUserSettings(theme);
  }

  static AppUserSettings fromEntity(AppUserSettingsEntity entity){
    return AppUserSettings(
      entity.theme
    );
  }
}