import 'dart:convert';

import 'package:flutter/material.dart';

class DeleteCategoryModel {
  final int? newCategoryId;  

  DeleteCategoryModel({
    this.newCategoryId,
  }); 

  Map<String, dynamic> toMap() {
    return {
      'newCategoryId': newCategoryId,
    };
  }  

  String toJson() => json.encode(toMap());
}
