part of 'settings_bloc.dart';

abstract class ThemeSettingsEvent extends Equatable{
  const ThemeSettingsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateThemesList extends ThemeSettingsEvent{
  final List<AppTheme> themes;

  UpdateThemesList(this.themes);

  @override
  List<Object> get props => [themes];
}

class GetAppSettings extends ThemeSettingsEvent{
  GetAppSettings();

  @override
  List<Object> get props => [];
}

class GetThemes extends ThemeSettingsEvent{
  final List<AppTheme> themes;

  GetThemes(this.themes);

  @override
  List<Object> get props => [themes];
}

class ThemeSelected extends ThemeSettingsEvent{
  final AppTheme? theme;

  ThemeSelected(this.theme);

  @override
  List<Object?> get props => [theme];
}

class SubmitTheme extends ThemeSettingsEvent{
  final AppTheme theme;

  SubmitTheme(this.theme);

  @override
  List<Object?> get props => [theme];
}

