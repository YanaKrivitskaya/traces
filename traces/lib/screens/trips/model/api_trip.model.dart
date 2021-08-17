
import 'dart:convert';
import 'package:flutter/material.dart';
import 'trip.model.dart';

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

  /*factory ApiTripModel.fromMap(Map<String, dynamic> map) {
    return ApiTripModel(
      userId: map['userId'],
      trip: Trip.fromMap(map['trip']),
    );
  }*/

  String toJson() => json.encode(toMap());

  //factory ApiTripModel.fromJson(String source) => ApiTripModel.fromMap(json.decode(source));
}
