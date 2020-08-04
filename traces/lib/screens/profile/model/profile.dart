import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/profile_entity.dart';

@immutable class Profile{
  final String email;
  final String displayName;
  final bool isEmailVerified;
  final String id;
  final List<String> familyMembers;

  Profile(this.email, this.familyMembers, {String displayName, String id, bool isEmailVerified})
      : this.id = id,
        this.isEmailVerified = isEmailVerified,
        this.displayName = displayName ?? '';

  Profile copyWith({String email, String displayName, bool isEmailVerified, List<String> familyMembers}){
    return Profile(
      email ?? this.email,
      familyMembers ?? this.familyMembers,
      displayName: displayName ?? this.displayName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified
    );
  }

  ProfileEntity toEntity(){
    return ProfileEntity(id, familyMembers, email, displayName, isEmailVerified);
  }

  static Profile fromEntity(ProfileEntity entity){
    return Profile(
        entity.email,
        entity.familyMembers,
        id: entity.id,
        displayName: entity.displayName,
        isEmailVerified: entity.isEmailVerified
    );
  }

}