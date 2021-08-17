
import 'dart:convert';

import 'package:flutter/material.dart';

@immutable
class ApiTripUsersModel {
  final List<int> userIds;

  ApiTripUsersModel(this.userIds);  

  Map<String, dynamic> toMap() {
    return {
      'userIds': userIds,
    };
  }

  String toJson() => json.encode(toMap());
}
