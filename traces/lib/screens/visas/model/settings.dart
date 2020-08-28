
import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/settings_entity.dart';

@immutable
class VisaSettings{
  final List<String> visaTypes;
  final List<String> entries;
  final List<String> transport;

  VisaSettings(this.visaTypes, this.entries, this.transport);

  VisaSettingsEntity toEntity(){
    return VisaSettingsEntity(visaTypes, entries, transport);
  }

  static VisaSettings fromEntity(VisaSettingsEntity entity){
    return VisaSettings(
        entity.visaTypes,
        entity.entries,
        entity.transport
    );
  }

}