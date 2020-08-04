
import 'package:flutter/material.dart';
import 'package:traces/screens/visas/model/entryExit_entity.dart';

@immutable class EntryExit{
  final String id;
  final DateTime entryDate;
  final String entryCountry;
  final DateTime exitDate;
  final String exitCountry;
  final bool hasExit;

  EntryExit(this.entryDate, this.entryCountry, {String id, DateTime exitDate, bool hasExit, String exitCountry})
      :this.exitDate = exitDate ?? DateTime.now(),
       this.id = id,
    this.exitCountry = exitCountry,
       this.hasExit = hasExit ?? false;

  EntryExitEntity toEntity(){
    return EntryExitEntity(id, entryDate, exitDate, hasExit, entryCountry, exitCountry);
  }

  static EntryExit fromEntity(EntryExitEntity entity){
    return EntryExit(
        entity.entryDate,
        entity.entryCountry,
        id: entity.id,
        exitDate: entity.exitDate,
        hasExit: entity.hasExit,
        exitCountry: entity.exitCountry
    );
  }

}