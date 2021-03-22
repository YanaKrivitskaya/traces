

import 'package:traces/screens/settings/model/theme_entity.dart';

abstract class AppSettingsRepository{
  Stream<List<Theme>> appThemes();
}