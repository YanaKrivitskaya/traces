

import 'package:traces/screens/settings/model/appSettings_entity.dart';
import 'package:traces/screens/settings/model/appUserSettings_entity.dart';

abstract class AppSettingsRepository{
  Future<AppSettings> generalSettings();
   Future<AppUserSettings> userSettings();
}