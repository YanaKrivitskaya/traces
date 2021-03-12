import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class VisaSettingsEntity extends Equatable{
  final List<String> visaTypes;
  final List<String> entries;
  final List<String> transport;

  VisaSettingsEntity(this.visaTypes, this.entries, this.transport);

  @override
  List<Object> get props => [visaTypes, entries, transport];

  Map<String, Object> toJson(){
    return{
      "visaTypes": visaTypes,
      "entries": entries,
      "transport": transport
    };
  }

  static VisaSettingsEntity fromMap(Map<dynamic, dynamic> map){
    return VisaSettingsEntity(
        map["visaTypes"].cast<String>() as List<String>,
        map["entries"].cast<String>() as List<String>,
        map["transport"].cast<String>() as List<String>
    );
  }

  static VisaSettingsEntity fromSnapshot(DocumentSnapshot snap){
    return VisaSettingsEntity(
        snap.data()['visaTypes'].cast<String>(),
        snap.data()['entries'].cast<String>(),
        snap.data()['transport'].cast<String>()
    );
  }

  Map<String, Object> toDocument(){
    return{
      "visaTypes": visaTypes,
      "entries": entries,
      "transport": transport
    };
  }
}


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