import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCountriesEntity extends Equatable{
  final List<String> countries;

  UserCountriesEntity(this.countries);

  @override
  List<Object> get props => [countries];

  Map<String, Object> toJson(){
    return{
      "countries": countries
    };
  }

  static UserCountriesEntity fromMap(Map<dynamic, dynamic> map){
    return UserCountriesEntity(
        map != null ? map["countries"].cast<String>() as List<String> : new List<String>()
    );
  }

  static UserCountriesEntity fromSnapshot(DocumentSnapshot snap){
    return UserCountriesEntity(
        snap.data()['countries'].cast<String>()
    );
  }

  Map<String, Object> toDocument(){
    return{
      "countries": countries,
    };
  }


}