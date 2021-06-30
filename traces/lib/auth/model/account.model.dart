import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Account {
  final int? id;
  final String? name;
  final String? email;
  final String? password;
  final bool? emailVerified;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? disabled;
  final DateTime? disabledDate;

  Account({    
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

  factory Account.fromMap(Map<String, dynamic> map) {    
    return Account(
      id: map['id'],
      name: map["name"],
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

  factory Account.fromJson(String source) => Account.fromMap(json.decode(source));
}
