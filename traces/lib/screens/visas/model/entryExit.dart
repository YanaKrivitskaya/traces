
import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/entryExit_entity.dart';

@immutable class EntryExit{
  final String id;
  final DateTime entryDate;
  final String entryCountry;
  final String entryCity;
  final String entryTransport;
  final DateTime exitDate;
  final String exitCountry;
  final String exitCity;
  final String exitTransport;
  final bool hasExit;

  EntryExit({DateTime entryDate, String entryCountry, String id, DateTime exitDate, bool hasExit,
    String exitCountry, String entryCity, String entryTransport, String exitCity, String exitTransport})
      : this.id = id,
        this.entryCountry = entryCountry ?? null,
        this.entryCity = entryCity ?? null,
        this.entryTransport = entryTransport ?? null,
        this.entryDate = entryDate ?? null,
        this.exitDate = exitDate ?? null,
        this.exitCountry = exitCountry ?? null,
        this.exitCity = exitCity ?? null,
        this.exitTransport = exitTransport ?? null,
        this.hasExit = hasExit ?? false;

  EntryExitEntity toEntity(){
    return EntryExitEntity(id, entryDate, entryCountry, entryCity, entryTransport, exitDate, exitCountry, exitCity, exitTransport, hasExit);
  }

  static EntryExit fromEntity(EntryExitEntity entity){
    return EntryExit(
        id: entity.id,
        entryDate: entity.entryDate,
        entryCountry: entity.entryCountry,
        entryCity: entity.entryCity,
        entryTransport: entity.entryTransport,
        exitDate: entity.exitDate,
        exitCountry: entity.exitCountry,
        exitCity: entity.exitCity,
        exitTransport: entity.exitTransport,
      hasExit: entity.hasExit,
    );
  }

}