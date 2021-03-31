import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AppUserSettingsEntity extends Equatable{
  String theme;

  AppUserSettingsEntity(this.theme);

  @override
  List<Object> get props => [theme];

  static AppUserSettingsEntity fromMap(Map<dynamic, dynamic> map){
    return AppUserSettingsEntity(
      map["theme"] as String
    );
  }

  static AppUserSettingsEntity fromSnapshot(DocumentSnapshot snap){
    return AppUserSettingsEntity(snap["theme"]);
  }

  Map<String, Object> toDocument(){
    return {
      "theme": theme
    };
  }
}

 class AppUserSettings{
  String theme;

  AppUserSettings(this.theme);

  AppUserSettings copyWith({String theme}){
    return AppUserSettings(      
      theme ?? this.theme
    );
  }

  AppUserSettingsEntity toEntity(){
    return AppUserSettingsEntity(theme);
  }

  static AppUserSettings fromEntity(AppUserSettingsEntity entity){
    return AppUserSettings(
      entity.theme
    );
  }
}