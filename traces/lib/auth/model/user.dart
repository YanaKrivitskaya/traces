import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool emailVerified;
  final DateTime createdDate;
  final DateTime updatedDate;
  final bool disabled;
  final DateTime disabledDate;

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
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      emailVerified: map['emailVerified'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate']),
      disabled: map['disabled'],
      disabledDate: DateTime.fromMillisecondsSinceEpoch(map['disabledDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
