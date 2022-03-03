import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

@immutable
class Booking {
  final int? id; 
  final int? expenseId; 
  final String? name;
  final String? location;
  final String? details; 
  final String? reservationNumber;
  final String? reservationUrl;
  final DateTime? entryDate;
  final DateTime? exitDate;
  final int? guestsQuantity;
  final String? image;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final Expense? expense;
  Booking({
    this.id,
    this.expenseId,
    this.name,
    this.location,
    this.details,    
    this.reservationNumber,
    this.reservationUrl,
    this.entryDate,
    this.exitDate,
    this.guestsQuantity,
    this.image,
    this.createdDate,
    this.updatedDate,
    this.expense
  });

  Booking copyWith({
    int? id,
    int? expenseId,
    String? name,
    String? location,
    String? details,
    String? description,
    DateTime? reservationDate,
    String? reservationNumber,
    String? reservationUrl,
    DateTime? entryDate,
    DateTime? exitDate,
    int? guestsQuantity,
    String? image,
    DateTime? createdDate,
    DateTime? updatedDate,
    Expense? expense
  }) {
    return Booking(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      name: name ?? this.name,
      location: location ?? this.location,
      details: details ?? this.details,      
      reservationNumber: reservationNumber ?? this.reservationNumber,
      reservationUrl: reservationUrl ?? this.reservationUrl,
      entryDate: entryDate ?? this.entryDate,
      exitDate: exitDate ?? this.exitDate,
      guestsQuantity: guestsQuantity ?? this.guestsQuantity,
      image: image ?? this.image,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      expense: expense ?? this.expense
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'details': details,     
      'reservationNumber': reservationNumber,
      'reservationUrl': reservationUrl,
      'entryDate': entryDate?.toIso8601String(),
      'exitDate': exitDate?.toIso8601String(),
      'guestsQuantity': guestsQuantity,
      'image': image,
      'createdDate': createdDate?.toIso8601String(),
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    print(map.length);
    return Booking(
      id: map['id'],
      expenseId: map['expenseId'],
      name: map['name'],
      location: map['location'],
      details: map['details'],     
      reservationNumber: map['reservationNumber'],
      reservationUrl: map['reservationUrl'],
      entryDate: map['entryDate'] != null ? DateTime.parse(map['entryDate']) : null,
      exitDate: map['exitDate'] != null ? DateTime.parse(map['exitDate']) : null,
      guestsQuantity: map['guestsQuantity'],
      image: map['image'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      expense: map['expense'] != null ? Expense.fromMap(map['expense']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Booking.fromJson(String source) => Booking.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Booking(id: $id, name: $name, details: $details, reservationNumber: $reservationNumber, reservationUrl: $reservationUrl, entryDate: $entryDate, exitDate: $exitDate, guestsQuantity: $guestsQuantity, image: $image, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Booking &&
      other.id == id &&
      other.expenseId == expenseId &&
      other.name == name &&
      other.location == location &&
      other.details == details &&      
      other.reservationNumber == reservationNumber &&
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
      location.hashCode ^
      details.hashCode ^      
      reservationNumber.hashCode ^
      reservationUrl.hashCode ^
      entryDate.hashCode ^
      exitDate.hashCode ^
      guestsQuantity.hashCode ^
      image.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
