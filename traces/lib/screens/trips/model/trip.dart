import 'package:traces/screens/trips/model/trip_entity.dart';

class Trip {
  final String? id;
  String? name;
  final String? description;
  final String? coverImageUrl;
  DateTime? startDate;
  DateTime? endDate;
  final List<String>? photoUrls;
  List<String>? tripMembers;

  Trip({
    this.id,
    this.name,
    this.description,
    this.coverImageUrl,
    this.startDate,
    this.endDate,
    this.photoUrls,
    this.tripMembers,
  });

 TripEntity toEntity(){
    return TripEntity(
      id: id, 
      name: name, 
      description: description, 
      coverImageUrl: coverImageUrl, 
      startDate: startDate, 
      endDate: endDate, 
      photoUrls: photoUrls, 
      tripMembers: tripMembers
    );
  }

  static Trip fromEntity(TripEntity entity){
    return Trip(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      coverImageUrl: entity.coverImageUrl,
      startDate: entity.startDate,
      endDate: entity.endDate,
      photoUrls: entity.photoUrls,
      tripMembers: entity.tripMembers
    );
  }
  @override
  String toString() {
    return 'Trip(id: $id, name: $name, description: $description, coverImageUrl: $coverImageUrl, startDate: $startDate, endDate: $endDate, photoUrls: $photoUrls, tripMembers: $tripMembers)';
  }

}
