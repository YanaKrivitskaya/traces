import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class User {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final bool? emailVerified;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? disabled;
  final DateTime? disabledDate;

  User({    
    this.id, 
    this.name, 
    this.email, 
    this.password,
    this.emailVerified,
    this.createdDate,
    this.updatedDate,
    this.disabled,
    this.disabledDate
  });  

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'emailVerified': emailVerified,
      'createdDate': createdDate?.millisecondsSinceEpoch,
      'updatedDate': updatedDate?.millisecondsSinceEpoch,
      'disabled': disabled,
      'disabledDate': disabledDate?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    var map1 = map;
    print(map1);
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      emailVerified: map['emailVerified'],
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
      disabled: map['disabled'],
      disabledDate: map['disabledDate'] != null ? DateTime.parse(map['disabledDate']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
