
import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/settings_entity.dart';

@immutable
class Settings{
  final List<String> visaTypes;
  final List<String> entries;

  Settings(this.visaTypes, this.entries);

  SettingsEntity toEntity(){
    return SettingsEntity(visaTypes, entries);
  }

  static Settings fromEntity(SettingsEntity entity){
    return Settings(
        entity.visaTypes,
        entity.entries
    );
  }

}