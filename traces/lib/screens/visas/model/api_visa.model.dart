
import 'dart:convert';

import 'package:flutter/material.dart';

import 'visa.model.dart';

@immutable
class ApiVisaModel {
  final int userId;
  final Visa visa;  
  ApiVisaModel({
    required this.userId,
    required this.visa,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'visa': visa.toMap(),
    };
  }

  factory ApiVisaModel.fromMap(Map<String, dynamic> map) {
    return ApiVisaModel(
      userId: map['userId'],
      visa: Visa.fromMap(map['visa']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiVisaModel.fromJson(String source) => ApiVisaModel.fromMap(json.decode(source));
}
