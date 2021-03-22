
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:traces/screens/settings/model/theme_entity.dart';

import '../model/appSettings_entity.dart';
import 'appSettings_repository.dart';

class FirebaseAppSettingsRepository extends AppSettingsRepository{
  final settingsCollection = FirebaseFirestore.instance.collection('appSettings');
  final String appThemesName = "themes";


  FirebaseAppSettingsRepository();

  @override 
  Stream<List<Theme>> appThemes() async*{
    
    yield* settingsCollection.doc(appThemesName).collection(appThemesName).snapshots()
      .map((snapshot){        
        return snapshot.docs
          .map((doc) => Theme.fromEntity(ThemeEntity.fromSnapshot(doc)))
          .toList();
      });
  }
}