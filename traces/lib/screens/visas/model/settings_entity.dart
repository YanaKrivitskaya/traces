import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsEntity extends Equatable{
  final List<String> visaTypes;
  final List<String> entries;

  SettingsEntity(this.visaTypes, this.entries);

  @override
  List<Object> get props => [visaTypes, entries];

  Map<String, Object> toJson(){
    return{
      "visaTypes": visaTypes,
      "entries": entries
    };
  }

  static SettingsEntity fromMap(Map<dynamic, dynamic> map){
    return SettingsEntity(
        map["visaTypes"].cast<String>() as List<String>,
        map["entries"].cast<String>() as List<String>
    );
  }

  static SettingsEntity fromSnapshot(DocumentSnapshot snap){
    return SettingsEntity(
        snap.data['visaTypes'].cast<String>(),
        snap.data['entries'].cast<String>()
    );
  }

  Map<String, Object> toDocument(){
    return{
      "visaTypes": visaTypes,
      "entries": entries,
    };
  }

}