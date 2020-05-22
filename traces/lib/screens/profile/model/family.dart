
import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/family_enitity.dart';

@immutable class Family{
  final String name;
  final String gender;
  final String id;

  Family(this.name, {String id, String gender})
      : this.id = id,
        this.gender = gender;

  Family copyWith({String name, String gender}){
    return Family(
      name ?? this.name,
      gender: gender ?? this.gender
    );
  }

  FamilyEntity toEntity(){
    return FamilyEntity(id, name, gender);
  }

  static Family fromEntity(FamilyEntity entity){
    return Family(
        entity.name,
        id: entity.id,
        gender: entity.gender
    );
  }

}