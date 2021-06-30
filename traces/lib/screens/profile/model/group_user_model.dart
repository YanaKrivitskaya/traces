import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class GroupUser {
  final int? userId;
  final int? accountId;
  final String name;
  final bool? isOwner;
  GroupUser({
    this.userId,
    this.accountId,
    required this.name,
    this.isOwner,
  });

  GroupUser copyWith({
    int? userId,
    String? name,
    bool? isOwner,
  }) {
    return GroupUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      isOwner: isOwner ?? this.isOwner,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,      
      'name': name,
      'isOwner': isOwner,
    };
  }

  factory GroupUser.fromMap(Map<String, dynamic> map) {
    return GroupUser(
      userId: map['id'],
      accountId: map['accountId'],
      name: map['name'],
      isOwner: map['user_group']?['isOwner'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupUser.fromJson(String source) => GroupUser.fromMap(json.decode(source));

  @override
  String toString() => 'GroupUser(userId: $userId, accountId: $accountId, name: $name, isOwner: $isOwner)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GroupUser &&
      other.userId == userId &&
      other.accountId == accountId &&
      other.name == name &&
      other.isOwner == isOwner;
  }

  @override
  int get hashCode => userId.hashCode ^ accountId.hashCode ^ name.hashCode ^ isOwner.hashCode;
}
