
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:traces/screens/trips/model/expense.model.dart';
import 'package:traces/screens/trips/model/activity.model.dart';

@immutable
class ApiActivityModel {  
  final int tripId;
  final Activity activity;  
  final Expense? expense;  
  ApiActivityModel({   
    required this.tripId,
    required this.activity,
    this.expense,
  });  

  Map<String, dynamic> toMap() {
    return {      
      'tripId': tripId,
      'activity': activity.toMap(),
      'expense': expense?.toMap(),
    };
  }
  String toJson() => json.encode(toMap());
 
}
