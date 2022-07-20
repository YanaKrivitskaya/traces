// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Currency {
  final int id;
  final String code;
  final String name;
  final DateTime createdDate;
  final DateTime? updatedDate;
  Currency({
    required this.id,
    required this.code,
    required this.name,
    required this.createdDate,
    this.updatedDate,
  });

  Currency copyWith({
    int? id,
    String? code,
    String? name,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Currency(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      createdDate: DateTime.parse(map['createdDate'])
    );
  }

  String toJson() => json.encode(toMap());

  factory Currency.fromJson(String source) => Currency.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Currency(id: $id, code: $code, name: $name, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(covariant Currency other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.code == code &&
      other.name == name &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      code.hashCode ^
      name.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
