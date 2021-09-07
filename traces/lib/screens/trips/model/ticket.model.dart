import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:traces/screens/trips/model/expense.model.dart';

@immutable
class Ticket {
  final int? id; 
  final int? expenseId;
  final String? departureLocation;
  final String? arrivalLocation;
  final DateTime? departureDatetime;
  final DateTime? arrivalDatetime;
  final String? type;
  final String? carrier;
  final String? carrierNumber;
  final int? quantity;
  final String? seats;
  final String? details;
  final String? reservationNumber;
  final String? reservationUrl;  
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final Expense? expense;
  Ticket({
    this.id,
    this.expenseId,
    this.departureLocation,
    this.arrivalLocation,
    this.departureDatetime,
    this.arrivalDatetime,
    this.type,
    this.carrier,
    this.carrierNumber,
    this.quantity,
    this.seats,
    this.details,
    this.reservationNumber,
    this.reservationUrl,
    this.createdDate,
    this.updatedDate,
    this.expense
  });
  

  Ticket copyWith({
    int? id,
    int? expenseId,
    String? departureLocation,
    String? arrivalLocation,
    DateTime? departureDatetime,
    DateTime? arrivalDatetime,
    String? type,
    String? carrier,
    String? carrierNumber,
    int? quantity,
    String? seats,
    String? details,
    String? reservationNumber,
    String? reservationUrl,
    DateTime? createdDate,
    DateTime? updatedDate,
    Expense? expense
  }) {
    return Ticket(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      departureLocation: departureLocation ?? this.departureLocation,
      arrivalLocation: arrivalLocation ?? this.arrivalLocation,
      departureDatetime: departureDatetime ?? this.departureDatetime,
      arrivalDatetime: arrivalDatetime ?? this.arrivalDatetime,
      type: type ?? this.type,
      carrier: carrier ?? this.carrier,
      carrierNumber: carrierNumber ?? this.carrierNumber,
      quantity: quantity ?? this.quantity,
      seats: seats ?? this.seats,
      details: details ?? this.details,
      reservationNumber: reservationNumber ?? this.reservationNumber,
      reservationUrl: reservationUrl ?? this.reservationUrl,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      expense: expense ?? this.expense
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenseId': expenseId,
      'departureLocation': departureLocation,
      'arrivalLocation': arrivalLocation,
      'departureDatetime': departureDatetime?.toIso8601String(),
      'arrivalDatetime': arrivalDatetime?.toIso8601String(),
      'type': type,
      'carrier': carrier,
      'carrierNumber': carrierNumber,
      'quantity': quantity,
      'seats': seats,
      'details': details,
      'reservationNumber': reservationNumber,
      'reservationUrl': reservationUrl
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      expenseId: map['expenseId'],
      departureLocation: map['departureLocation'],
      arrivalLocation: map['arrivalLocation'],
      departureDatetime: map['departureDatetime'] != null ? DateTime.parse(map['departureDatetime']) : null,
      arrivalDatetime: map['arrivalDatetime'] != null ? DateTime.parse(map['arrivalDatetime']) : null,
      type: map['type'],
      carrier: map['carrier'],
      carrierNumber: map['carrierNumber'],
      quantity: map['quantity'],
      seats: map['seats'],
      details: map['details'],
      reservationNumber: map['reservationNumber'],
      reservationUrl: map['reservationUrl'],
      createdDate: map['createdDate'] != null ? DateTime.parse(map['createdDate']) : null,
      updatedDate: map['updatedDate'] != null ? DateTime.parse(map['updatedDate']) : null,
      expense: map['expense'] != null ? Expense.fromMap(map['expense']) : null
    );
  }

  String toJson() => json.encode(toMap());

  factory Ticket.fromJson(String source) => Ticket.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Ticket(id: $id, expenseId: $expenseId, departureLocation: $departureLocation, arrivalLocation: $arrivalLocation, departureDatetime: $departureDatetime, arrivalDatetime: $arrivalDatetime, type: $type, carrier: $carrier, carrierNumber: $carrierNumber, quantity: $quantity, seats: $seats, details: $details, reservationNumber: $reservationNumber, reservationUrl: $reservationUrl, createdDate: $createdDate, updatedDate: $updatedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Ticket &&
      other.id == id &&
      other.expenseId == expenseId &&
      other.departureLocation == departureLocation &&
      other.arrivalLocation == arrivalLocation &&
      other.departureDatetime == departureDatetime &&
      other.arrivalDatetime == arrivalDatetime &&
      other.type == type &&
      other.carrier == carrier &&
      other.carrierNumber == carrierNumber &&
      other.quantity == quantity &&
      other.seats == seats &&
      other.details == details &&
      other.reservationNumber == reservationNumber &&
      other.reservationUrl == reservationUrl &&
      other.createdDate == createdDate &&
      other.updatedDate == updatedDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      expenseId.hashCode ^
      departureLocation.hashCode ^
      arrivalLocation.hashCode ^
      departureDatetime.hashCode ^
      arrivalDatetime.hashCode ^
      type.hashCode ^
      carrier.hashCode ^
      carrierNumber.hashCode ^
      quantity.hashCode ^
      seats.hashCode ^
      details.hashCode ^
      reservationNumber.hashCode ^
      reservationUrl.hashCode ^
      createdDate.hashCode ^
      updatedDate.hashCode;
  }
}
