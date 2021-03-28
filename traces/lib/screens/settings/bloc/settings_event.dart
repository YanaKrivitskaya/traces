part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable{
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateThemesList extends SettingsEvent{
  final List<String> themes;

  UpdateThemesList(this.themes);

  @override
  List<Object> get props => [themes];
}

class GetUserSettings extends SettingsEvent{
  GetUserSettings();

  @override
  List<Object> get props => [];
}

class GetAppSettings extends SettingsEvent{
  GetAppSettings();

  @override
  List<Object> get props => [];
}

class GetThemes extends SettingsEvent{
  final List<String> themes;

  GetThemes(this.themes);

  @override
  List<Object> get props => [themes];
}