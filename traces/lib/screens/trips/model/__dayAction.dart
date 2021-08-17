
import 'package:meta/meta.dart';
import '__dayAction_entity.dart';

@immutable
class DayAction {
  final String? id;
  final String? name;
  final String? description;
  final DateTime? date;
  final bool? isPlanned;
  final bool? isCompleted;
  final String? photoUrl;

  DayAction({
    this.id,
    this.name,
    this.description,
    this.date,
    this.isPlanned,
    this.isCompleted,
    this.photoUrl,
  });

  DayActionEntity toEntity(){
    return DayActionEntity(id, name, description, date, isPlanned, isCompleted, photoUrl);
  }

  static DayAction fromEntity(DayActionEntity entity){
    return DayAction(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      date: entity.date,
      isPlanned: entity.isPlanned,
      isCompleted: entity.isCompleted,
      photoUrl: entity.photoUrl
    );
  }

  @override
  String toString() {
    return 'DayAction(id: $id, name: $name, description: $description, date: $date, isPlanned: $isPlanned, isCompleted: $isCompleted, photoUrl: $photoUrl)';
  }

 /* @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DayAction &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.date == date &&
      other.isPlanned == isPlanned &&
      other.isCompleted == isCompleted &&
      other.photoUrl == photoUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      date.hashCode ^
      isPlanned.hashCode ^
      isCompleted.hashCode ^
      photoUrl.hashCode;
  }*/
}
