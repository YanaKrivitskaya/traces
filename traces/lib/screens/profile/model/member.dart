import 'package:flutter/material.dart';
import 'package:traces/screens/profile/model/member_entity.dart';

@immutable
class Member{  
  final String id;
  final String name;

  Member(this.id, this.name);

  MemberEntity toEntity(){
    return MemberEntity(id,  name);
  }

  static Member fromEntity(MemberEntity entity){
    return Member(
      entity.id,
      entity.name
    );
  }
}