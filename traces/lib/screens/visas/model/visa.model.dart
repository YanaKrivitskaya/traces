import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:traces/screens/profile/model/group_user_model.dart';
import 'package:traces/screens/visas/model/visa_entry.model.dart';
import 'package:traces/screens/visas/model/visa_settings.model.dart';

@immutable
class Visa {
  final int? id;  
  final int? createdBy;
  final String? country;
  final String? type;
  final String? entriesType;
  final int? durationOfStay;
  final DateTime? startDate;
  final DateTime? endDate;
  final GroupUser? user;
  final List<VisaEntry>? entries;

  Visa({
    this.id,
    this.createdBy,
    this.country,
    this.type,
    this.entriesType,
    this.durationOfStay,
    this.startDate,
    this.endDate,
    this.user,
    this.entries,
  });

  Visa copyWith({
    int? id,
    int? createdBy,
    String? country,
    String? type,
    String? entriesType,
    int? durationOfStay,
    DateTime? startDate,
    DateTime? endDate,
    GroupUser? user,
    List<VisaEntry>? entries,
  }) {
    return Visa(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      country: country ?? this.country,
      type: type ?? this.type,
      entriesType: entriesType ?? this.entriesType,
      durationOfStay: durationOfStay ?? this.durationOfStay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      user: user ?? this.user,
      entries: entries ?? this.entries,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,      
      'country': country,
      'type': type,
      'entriesType': entriesType,
      'durationOfStay': durationOfStay,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String()      
    };
  }

  factory Visa.fromMap(Map<String, dynamic> map) {
    return Visa(
      id: map['id'],
      createdBy: map['createdBy'],
      country: map['country'],
      type: map['type'],
      entriesType: map['entriesType'],
      durationOfStay: map['durationOfStay'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      user: GroupUser.fromMap(map['user']),
      entries: map['visa_entries'] != null ? List<VisaEntry>.from(map['visa_entries']?.map((x) => VisaEntry.fromMap(x))) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Visa.fromJson(String source) => Visa.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Visa(id: $id, createdBy: $createdBy, country: $country, type: $type, entriesType: $entriesType, durationOfStay: $durationOfStay, startDate: $startDate, endDate: $endDate, user: $user, entries: $entries)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return other is Visa &&
      other.id == id &&
      other.createdBy == createdBy &&
      other.country == country &&
      other.type == type &&
      other.entriesType == entriesType &&
      other.durationOfStay == durationOfStay &&
      other.startDate == startDate &&
      other.endDate == endDate &&
      other.user == user &&
      listEquals(other.entries, entries);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      createdBy.hashCode ^
      country.hashCode ^
      type.hashCode ^
      entriesType.hashCode ^
      durationOfStay.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      user.hashCode ^
      entries.hashCode;
  }
}
