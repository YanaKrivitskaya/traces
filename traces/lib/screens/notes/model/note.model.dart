import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Note {
  final int id;
  final int userId;
  final String title;
  final String content;  
  final DateTime createdDate;
  final DateTime updatedDate;
  final bool deleted;
  Note({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.createdDate,
    this.updatedDate,
    this.deleted,
  });

  /*Note copyWith({
    int? id,
    int? userId,
    String? title,
    String? content,
    DateTime? createdDate,
    DateTime? updatedDate,
    bool? deleted,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      deleted: deleted ?? this.deleted,
    );
  }*/

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'updatedDate': updatedDate.millisecondsSinceEpoch,
      'deleted': deleted,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      createdDate: DateTime.fromMillisecondsSinceEpoch(map['createdDate']),
      updatedDate: DateTime.fromMillisecondsSinceEpoch(map['updatedDate']),
      deleted: map['deleted'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, title: $title, content: $content, createdDate: $createdDate, updatedDate: $updatedDate, deleted: $deleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Note &&
      other.id == id &&
      other.userId == userId &&
      other.title == title &&
      other.content == content &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate &&
      other.deleted == deleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      content.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode ^
      deleted.hashCode;
  }
}

enum SortFields{
  TITLE,
  DATECREATED,
  DATEMODIFIED
}
enum SortDirections{
  ASC,
  DESC
}