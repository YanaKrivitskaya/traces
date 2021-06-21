import 'entryExit_entity.dart';

class EntryExit{
  final String? id;
  DateTime? entryDate;
  String? entryCountry;
  String? entryCity;
  String? entryTransport;
  DateTime? exitDate;
  String? exitCountry;
  String? exitCity;
  String? exitTransport;
  int? duration;
  bool hasExit;

  EntryExit({DateTime? entryDate, String? entryCountry, String? id, DateTime? exitDate, int? duration, bool? hasExit,
    String? exitCountry, String? entryCity, String? entryTransport, String? exitCity, String? exitTransport})
      : this.id = id,
        this.entryCountry = entryCountry ?? null,
        this.entryCity = entryCity ?? null,
        this.entryTransport = entryTransport ?? null,
        this.entryDate = entryDate ?? null,
        this.exitDate = exitDate ?? null,
        this.exitCountry = exitCountry ?? null,
        this.exitCity = exitCity ?? null,
        this.exitTransport = exitTransport ?? null,
        this.duration = duration ?? null,
        this.hasExit = hasExit ?? false;

  EntryExitEntity toEntity(){
    return EntryExitEntity(id, entryDate, entryCountry, entryCity, entryTransport, exitDate, exitCountry, exitCity, exitTransport, duration, hasExit);
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
        duration: entity.duration,
        hasExit: entity.hasExit,
    );
  }

}