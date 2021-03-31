part of 'settings_bloc.dart';

abstract class SettingsState{
  final AppSettings settings;
  final String userTheme;

  const SettingsState({this.settings, this.userTheme});

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
  final String selectedTheme;
  final String userTheme;
  
  const SuccessSettingsState(this.settings, this.selectedTheme, this.userTheme)
    :super(settings: settings, userTheme: userTheme);

  @override
  List<Object> get props => [settings, selectedTheme, userTheme];
}