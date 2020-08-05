

import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/visa_entity.dart';

@immutable class Visa{
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String countryOfIssue;
  final String durationOfStay;
  final String numberOfEntries;
  final String owner;
  final List<String> entryExitIds;
  final String type;

  Visa(this.startDate,
      this.endDate,
      this.countryOfIssue,
      this.durationOfStay,
      this.numberOfEntries, this.owner,
      {String id, List<String> entryExitIds, String type, String validCountries})
      : this.id = id,
        this.entryExitIds = entryExitIds ?? new List<String>(),
        this.type = type;

  VisaEntity toEntity(){
    return VisaEntity(id, startDate, endDate, countryOfIssue, durationOfStay, numberOfEntries, entryExitIds, type, owner);
  }

  static Visa fromEntity(VisaEntity entity){
    return Visa(
        entity.startDate,
        entity.endDate,
        entity.countryOfIssue,
        entity.durationOfStay,
        entity.numberOfEntries,
        entity.memberId,
        id: entity.id,
        entryExitIds: entity.entryExitIds,
        type: entity.type
    );
  }

}