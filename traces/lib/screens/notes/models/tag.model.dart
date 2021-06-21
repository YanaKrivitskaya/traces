import 'dart:convert';


class Tag {
  final int? id;
  final int? userId;
  final String? name;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final bool? deleted;
  final DateTime? deletedDate;
  bool? isChecked;
  Tag({
    this.id,
    this.userId,
    this.name,
    this.createdDate,
    this.updatedDate,
    this.deleted,
    this.deletedDate,
    this.isChecked,
  });


  /*Tag copyWith({
    int? id,
    int? userId,
    String? name,
    DateTime? createdDate,
    DateTime? updatedDate,
    bool? deleted,
    bool? isChecked,
  }) {
    return Tag(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      deleted: deleted ?? this.deleted,
      isChecked: isChecked ?? this.isChecked,
    );
  }*/

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'createdDate': createdDate?.millisecondsSinceEpoch,
      'updatedDate': updatedDate?.millisecondsSinceEpoch,
      'deleted': deleted,
      'deletedDate': deletedDate?.millisecondsSinceEpoch,
      'isChecked': isChecked,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      deleted: map['deleted'],
      deletedDate: map['deletedDate'] != null ? DateTime.parse(map['deletedDate']) : null,
      isChecked: map['isChecked'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Tag(id: $id, userId: $userId, name: $name, createdDate: $createdDate, updatedDate: $updatedDate, deleted: $deleted, , deletedDate: $deletedDate, isChecked: $isChecked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tag &&
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
