import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class Ticket {
  final int? id; 
  final int? expenseId; 
  final String name;
  final String? details;
  final String? description;
  final DateTime? reservationDate;
  final String? reservationNUmber;
  final String? reservationUrl;
  final DateTime? entryDate;
  final DateTime? exitDate;
  final int? guestsQuantity;
  final String? image;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  Ticket({
    this.id,
    this.expenseId,
    required this.name,
    this.details,
    this.description,
    this.reservationDate,
    this.reservationNUmber,
    this.reservationUrl,
    this.entryDate,
    this.exitDate,
    this.guestsQuantity,
    this.image,
    this.createdDate,
    this.updatedDate,
  });

  Ticket copyWith({
    int? id,
    int? expenseId,
    String? name,
    String? details,
    String? description,
    DateTime? reservationDate,
    String? reservationNUmber,
    String? reservationUrl,
    DateTime? entryDate,
    DateTime? exitDate,
    int? guestsQuantity,
    String? image,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Ticket(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      details: details ?? this.details,
      description: description ?? this.description,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationNUmber: reservationNUmber ?? this.reservationNUmber,
      reservationUrl: reservationUrl ?? this.reservationUrl,
      entryDate: entryDate ?? this.entryDate,
      exitDate: exitDate ?? this.exitDate,
      guestsQuantity: guestsQuantity ?? this.guestsQuantity,
      image: image ?? this.image,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenseId': expenseId,
      'name': name,
      'details': details,
      'description': description,
      'reservationDate': reservationDate?.toIso8601String(),
      'reservationNUmber': reservationNUmber,
      'reservationUrl': reservationUrl,
      'entryDate': entryDate?.toIso8601String(),
      'exitDate': exitDate?.toIso8601String(),
      'guestsQuantity': guestsQuantity,
      'image': image
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      expenseId: map['expenseId'],
      name: map['name'],
      details: map['details'],
      description: map['description'],
      reservationDate: map['reservationDate'] != null ? DateTime.parse(map['reservationDate']) : null,
      reservationNUmber: map['reservationNUmber'],
      reservationUrl: map['reservationUrl'],
      entryDate: map['entryDate'] != null ? DateTime.parse(map['entryDate']) : null,
      exitDate: map['exitDate'] != null ? DateTime.parse(map['exitDate']) : null,
      guestsQuantity: map['guestsQuantity'],
      image: map['image'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ticket(id: $id, expenseId: $expenseId, name: $name, details: $details, description: $description, reservationDate: $reservationDate, reservationNUmber: $reservationNUmber, reservationUrl: $reservationUrl, entryDate: $entryDate, exitDate: $exitDate, guestsQuantity: $guestsQuantity, image: $image, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Ticket &&
      other.id == id &&
      other.expenseId == expenseId &&
      other.name == name &&
      other.details == details &&
      other.description == description &&
      other.reservationDate == reservationDate &&
      other.reservationNUmber == reservationNUmber &&
      other.reservationUrl == reservationUrl &&
      other.entryDate == entryDate &&
      other.exitDate == exitDate &&
      other.guestsQuantity == guestsQuantity &&
      other.image == image &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      expenseId.hashCode ^
      name.hashCode ^
      details.hashCode ^
      description.hashCode ^
      reservationDate.hashCode ^
      reservationNUmber.hashCode ^
      reservationUrl.hashCode ^
      entryDate.hashCode ^
      exitDate.hashCode ^
      guestsQuantity.hashCode ^
      image.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
