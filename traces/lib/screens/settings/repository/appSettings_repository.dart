

import '../model/appSettings_entity.dart';
import '../model/appUserSettings_entity.dart';

abstract class AppSettingsRepository{
  Future<AppSettings> generalSettings();
  Future<AppUserSettings> userSettings();
  Future<AppUserSettings> updateUserSettings(AppUserSettings settings);
}