part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable{
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateThemesList extends SettingsEvent{
  final List<AppTheme> themes;

  UpdateThemesList(this.themes);

  @override
  List<Object> get props => [themes];
}

class GetAppSettings extends SettingsEvent{
  GetAppSettings();

  @override
  List<Object> get props => [];
}

class GetThemes extends SettingsEvent{
  final List<AppTheme> themes;

  GetThemes(this.themes);

  @override
  List<Object> get props => [themes];
}

class ThemeSelected extends SettingsEvent{
  final AppTheme? theme;

  ThemeSelected(this.theme);

  @override
  List<Object?> get props => [theme];
}

class SubmitTheme extends SettingsEvent{
  final AppTheme theme;

  SubmitTheme(this.theme);

  @override
  List<Object?> get props => [theme];
}

