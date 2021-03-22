import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeEntity extends Equatable{
  final String id;
  final String name;

  ThemeEntity(this.id, this.name);

  @override  
  List<Object> get props => [id, name];

  static ThemeEntity fromMap(Map<dynamic, dynamic> map, String documentId){
    return ThemeEntity(
      documentId,
      map["name"] as String
    );
  }

  static ThemeEntity fromSnapshot(DocumentSnapshot snap){
    return ThemeEntity(
      snap.id,
      snap.data()["name"]
    );
  }

  Map<String, Object> toDocument(){
    return{
      "name": name
    };
  }
}

@immutable class Theme{
  final String id;
  final String name;

  Theme(this.id, this.name);

  Theme copyWith({String name}){
    return Theme(
      this.id,
      name ?? this.name
    );
  }

  ThemeEntity toEntity(){
    return ThemeEntity(id, name);
  }

  static Theme fromEntity(ThemeEntity entity){
    return Theme(
      entity.id,
      entity.name
    );
  }
}