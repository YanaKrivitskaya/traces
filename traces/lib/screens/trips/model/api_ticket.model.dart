
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/ticket.model.dart';

import 'trip.model.dart';

@immutable
class ApiTicketModel {
  final int? userId;
  final int tripId;
  final Ticket ticket;  
  final Expense? expense;  
  ApiTicketModel({
    this.userId,
    required this.tripId,
    required this.ticket,
    this.expense,
  });  

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'ticket': ticket.toMap(),
      'expense': expense?.toMap(),
    };
  }
  String toJson() => json.encode(toMap());
 
}
