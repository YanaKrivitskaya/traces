
import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/profile_entity.dart';

@immutable class Profile{
  final String email;
  final String displayName;
  final bool isEmailVerified;
  final String id;

  Profile(this.email, {String displayName, String id, bool isEmailVerified})
      : this.id = id,
        this.isEmailVerified = isEmailVerified,
        this.displayName = displayName ?? '';

  Profile copyWith({String email, String displayName, bool isEmailVerified}){
    return Profile(
      email ?? this.email,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? isEmailVerified
    );
  }

  ProfileEntity toEntity(){
    return ProfileEntity(id, email, displayName, isEmailVerified);
  }

  static Profile fromEntity(ProfileEntity entity){
    return Profile(
        entity.email,
        id: entity.id,
        displayName: entity.displayName,
        isEmailVerified: entity.isEmailVerified
    );
  }

}