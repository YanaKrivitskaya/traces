import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'group_user_model.dart';

@immutable
class Group {
  final int? id;
  final String name;
  final int ownerAccountId;
  final List<GroupUser> users;  
  Group({
    this.id,
    required this.name,
    required this.ownerAccountId,
    required this.users,
  });

  Group copyWith({
    int? id,
    String? name,
    int? ownerAccountId,
    List<GroupUser>? users,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerAccountId: ownerAccountId ?? this.ownerAccountId,
      users: users ?? this.users,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ownerAccountId': ownerAccountId,
      'users': users.map((x) => x.toMap()).toList(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      ownerAccountId: map['ownerAccountId'],
      users: List<GroupUser>.from(map['users']?.map((x) => GroupUser.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(id: $id, name: $name, ownerAccountId: $ownerAccountId, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is Group &&
      other.id == id &&
      other.name == name &&
      other.ownerAccountId == ownerAccountId &&
      listEquals(other.users, users);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      ownerAccountId.hashCode ^
      users.hashCode;
  }
}
