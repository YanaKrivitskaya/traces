part of 'settings_bloc.dart';

abstract class AppSettingsEvent extends Equatable{
  const AppSettingsEvent();

  @override
  List<Object?> get props => [];
}

class UpdateThemesList extends AppSettingsEvent{
  final List<AppTheme> themes;

  UpdateThemesList(this.themes);

  @override
  List<Object> get props => [themes];
}

class GetAppSettings extends AppSettingsEvent{
  GetAppSettings();

  @override
  List<Object> get props => [];
}

class GetThemes extends AppSettingsEvent{
  final List<AppTheme> themes;

  GetThemes(this.themes);

  @override
  List<Object> get props => [themes];
}

class ThemeSelected extends AppSettingsEvent{
  final AppTheme? theme;

  ThemeSelected(this.theme);

  @override
  List<Object?> get props => [theme];
}

class MenuSelected extends AppSettingsEvent{
  final AppMenu menu;

  MenuSelected(this.menu);

  @override
  List<Object?> get props => [menu];
}

class SubmitTheme extends AppSettingsEvent{
  final AppTheme theme;

  SubmitTheme(this.theme);

  @override
  List<Object?> get props => [theme];
}

class SubmitMenu extends AppSettingsEvent{
  final AppMenu menu;

  SubmitMenu(this.menu);

  @override
  List<Object?> get props => [menu];
}

