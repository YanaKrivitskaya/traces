import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/trip.model.dart';

import 'tag.model.dart';

@immutable
class Note {
  final int? id;
  final int? userId;  
  final String? title;
  final String? content;  
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? deleted;
  final DateTime? deletedDate;
  List<Tag>? tags;
  final Trip? trip;

  Note({
    this.id,
    this.userId,
    this.title,
    this.content,
    this.createdDate,
    this.updatedDate,
    this.deleted,
    this.deletedDate,
    this.tags,
    this.trip
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
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
      'deletedDate': deletedDate?.toIso8601String(),
      'deleted': deleted,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {  

    return Note(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      createdDate: DateTime.parse(map['createdDate']),
      updatedDate: DateTime.parse(map['updatedDate']),
      deleted: map['deleted'],
      deletedDate: map['deletedDate'] != null ? DateTime.parse(map['deletedDate']) : null,
      tags: map["tags"]!= null ? 
      map['tags'].map<Tag>((map) => Tag.fromMap(map)).toList() : null,
      trip: map['trip'] != null ? Trip.fromMap(map["trip"]) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, userId: $userId, title: $title, content: $content, createdDate: $createdDate, updatedDate: $updatedDate, deleted: $deleted, deletedDate: $deletedDate)';
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
      other.deletedDate == deletedDate &&
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
      deletedDate.hashCode ^
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