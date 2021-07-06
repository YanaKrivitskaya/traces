import 'dart:convert';

import 'package:meta/meta.dart';

@immutable
class VisaEntry {
  final int? id;
  final int visaId; 
  final String? entryCountry;
  final String? entryCity;
  final String? entryTransport;  
  final DateTime entryDate;
  final bool? hasExit;
  final String? exitCountry;
  final String? exitCity;
  final String? exitTransport;  
  final DateTime? exitDate;  

  VisaEntry({
    this.id,
    required this.visaId,
    this.entryCountry,
    this.entryCity,
    this.entryTransport,
    required this.entryDate,
    this.hasExit,
    this.exitCountry,
    this.exitCity,
    this.exitTransport,
    this.exitDate
  });

  VisaEntry copyWith({
    int? id,
    int? visaId,
    String? entryCountry,
    String? entryCity,
    String? entryTransport,
    DateTime? entryDate,
    bool? hasExit,
    String? exitCountry,
    String? exitCity,
    String? exitTransport,
    DateTime? exitDate
  }) {
    return VisaEntry(
      id: id ?? this.id,
      visaId: visaId ?? this.visaId,
      entryCountry: entryCountry ?? this.entryCountry,
      entryCity: entryCity ?? this.entryCity,
      entryTransport: entryTransport ?? this.entryTransport,
      entryDate: entryDate ?? this.entryDate,
      hasExit: hasExit ?? this.hasExit,
      exitCountry: exitCountry ?? this.exitCountry,
      exitCity: exitCity ?? this.exitCity,
      exitTransport: exitTransport ?? this.exitTransport,
      exitDate: exitDate ?? this.exitDate
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'visaId': visaId,
      'entryCountry': entryCountry,
      'entryCity': entryCity,
      'entryTransport': entryTransport,
      'entryDate': entryDate.toIso8601String(),
      'hasExit': hasExit,
      'exitCountry': exitCountry,
      'exitCity': exitCity,
      'exitTransport': exitTransport,
      'exitDate': exitDate?.toIso8601String()
    };
  }

  factory VisaEntry.fromMap(Map<String, dynamic> map) {
    return VisaEntry(
      id: map['id'],
      visaId: map['visaId'],
      entryCountry: map['entryCountry'],
      entryCity: map['entryCity'],
      entryTransport: map['entryTransport'],
      entryDate: DateTime.parse(map['entryDate']),
      hasExit: map['hasExit'],
      exitCountry: map['exitCountry'],
      exitCity: map['exitCity'],
      exitTransport: map['exitTransport'],
      exitDate: map['exitDate'] != null ? DateTime.parse(map['exitDate']) : null      
    );
  }

  String toJson() => json.encode(toMap());

  factory VisaEntry.fromJson(String source) => VisaEntry.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VisaEntry(id: $id, visaId: $visaId, entryCountry: $entryCountry, entryCity: $entryCity, entryTransport: $entryTransport, entryDate: $entryDate, hasExit: $hasExit, exitCountry: $exitCountry, exitCity: $exitCity, exitTransport: $exitTransport, exitDate: $exitDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is VisaEntry &&
      other.id == id &&
      other.visaId == visaId &&
      other.entryCountry == entryCountry &&
      other.entryCity == entryCity &&
      other.entryTransport == entryTransport &&
      other.entryDate == entryDate &&
      other.hasExit == hasExit &&
      other.exitCountry == exitCountry &&
      other.exitCity == exitCity &&
      other.exitTransport == exitTransport &&
      other.exitDate == exitDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      visaId.hashCode ^
      entryCountry.hashCode ^
      entryCity.hashCode ^
      entryTransport.hashCode ^
      entryDate.hashCode ^
      hasExit.hashCode ^
      exitCountry.hashCode ^
      exitCity.hashCode ^
      exitTransport.hashCode ^
      exitDate.hashCode;
  }
}
