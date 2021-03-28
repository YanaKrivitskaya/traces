part of 'settings_bloc.dart';

abstract class SettingsState{
  final AppSettings settings;  

  const SettingsState({this.settings});

  @override
  List<Object> get props => [];
}

class LoadingSettingsState extends SettingsState{
  LoadingSettingsState(AppSettings settings)
    :super(settings: settings);
}

class InitialSettingsState extends SettingsState{
  InitialSettingsState(AppSettings settings)
    :super(settings: settings);
}

class SuccessSettingsState extends SettingsState{
  final AppSettings settings;
  
  const SuccessSettingsState(this.settings)
    :super(settings: settings);

  @override
  List<Object> get props => [settings];
}