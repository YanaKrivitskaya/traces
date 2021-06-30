import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'group_model.dart';

@immutable
class Profile {
  final int accountId;
  final int userId;
  final String name;
  final String email;
  final bool emailVerified;
  final List<Group>? groups;  
  Profile({
    required this.accountId,
    required this.userId,
    required this.name,
    required this.email,
    required this.emailVerified,
    this.groups,
  });

  Profile copyWith({
    int? accountId,
    int? userId,
    String? name,
    String? email,
    bool? emailVerified,
    List<Group>? groups,
  }) {
    return Profile(
      accountId: accountId ?? this.accountId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'userId': userId,
      'name': name,
      'email': email,
      'emailVerified': emailVerified,
      'groups': groups?.map((x) => x.toMap()).toList(),
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      accountId: map['accountId'],
      userId: map['user']['id'],
      name: map['user']['name'],
      email: map['email'],
      emailVerified: map['emailVerified'],
      groups: List<Group>.from(map['user']['groups']?.map((x) => Group.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) => Profile.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Profile(accountId: $accountId, userId: $userId, name: $name, email: $email, emailVerified: $emailVerified, groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is Profile &&
      other.accountId == accountId &&
      other.userId == userId &&
      other.name == name &&
      other.email == email &&
      other.emailVerified == emailVerified &&
      listEquals(other.groups, groups);
  }

  @override
  int get hashCode {
    return accountId.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      email.hashCode ^
      emailVerified.hashCode ^
      groups.hashCode;
  }
}
