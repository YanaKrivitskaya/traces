
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traces/screens/trips/model/booking.model.dart';

import 'package:traces/screens/trips/model/expense.model.dart';

@immutable
class ApiBookingModel {
  final int tripId;
  final Booking booking;  
  final Expense? expense;  
  ApiBookingModel({
    required this.tripId,
    required this.booking,
    this.expense,
  });  

  Map<String, dynamic> toMap() {
    return {
      'tripId': tripId,
      'booking': booking.toMap(),
      'expense': expense?.toMap(),
    };
  }
  String toJson() => json.encode(toMap());
 
}
