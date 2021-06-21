
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/appSettings_entity.dart';
import '../model/appUserSettings_entity.dart';
import 'appSettings_repository.dart';

class FirebaseAppSettingsRepository{
  final settingsCollection = FirebaseFirestore.instance.collection('appSettings');
  final String appSettingsRef = "general";
  //FirebaseUserRepository _userRepository;

  FirebaseAppSettingsRepository(){
    //_userRepository = new FirebaseUserRepository();    
  }

  @override 
  Future<AppSettings> generalSettings() async{    
    var res = await settingsCollection.doc(appSettingsRef).get();

    return AppSettings.fromEntity(AppSettingsEntity.fromMap(res.data()!));
  }

  @override
  Future<void> userSettings() async{
    /*String uid = await _userRepository.getUserId();
    var resultSettings = await settingsCollection.doc(uid).get();
    return AppUserSettings.fromEntity(AppUserSettingsEntity.fromMap(resultSettings.data()));*/
  }

  @override
  Future<void> updateUserSettings(AppUserSettings settings) async{
   /* String uid = await _userRepository.getUserId();
       
    await settingsCollection.doc(uid).set(settings.toEntity().toDocument());
    
    return await userSettings();*/
  }
}