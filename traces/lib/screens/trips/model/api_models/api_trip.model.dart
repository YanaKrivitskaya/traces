
import 'dart:convert';

import 'package:flutter/material.dart';

import '../trip.model.dart';

@immutable
class ApiTripModel {
  final int userId;
  final Trip trip;  
  ApiTripModel({
    required this.userId,
    required this.trip,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'trip': trip.toMap(),
    };
  }
  String toJson() => json.encode(toMap());
}
