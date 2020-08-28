

import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/visa_entity.dart';

@immutable class Visa{
  final String id;
  DateTime startDate;
  DateTime endDate;
  String countryOfIssue;
  int durationOfStay;
  String numberOfEntries;
  String owner;
  String type;
  final DateTime dateCreated;
  final DateTime dateModified;

  Visa({
    DateTime startDate,
    DateTime endDate,
    String countryOfIssue,
    int durationOfStay,
    String numberOfEntries,
    String owner,
    String id,
    List<String> entryExitIds,
    String type,
    DateTime dateCreated,
    DateTime dateModified}) :
        this.id = id,
        this.startDate = startDate,
        this.endDate = endDate,
        this.countryOfIssue = countryOfIssue,
        this.durationOfStay = durationOfStay,
        this.numberOfEntries = numberOfEntries,
        this.owner = owner,
        this.type = type,
        this.dateCreated = dateCreated ?? DateTime.now(),
        this.dateModified = dateModified ?? DateTime.now();

  VisaEntity toEntity(){
    return VisaEntity(id, startDate, endDate, countryOfIssue, durationOfStay, numberOfEntries, type, owner, dateCreated, dateModified);
  }

  static Visa fromEntity(VisaEntity entity){
    return Visa(
        startDate: entity.startDate,
        endDate: entity.endDate,
        countryOfIssue: entity.countryOfIssue,
        durationOfStay: entity.durationOfStay,
        numberOfEntries: entity.numberOfEntries,
        owner: entity.owner,
        id: entity.id,
        type: entity.type,
        dateCreated: entity.dateCreated,
        dateModified: entity.dateModified,
    );
  }

}