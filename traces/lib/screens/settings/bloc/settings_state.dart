part of 'settings_bloc.dart';

abstract class SettingsState{
  final List<String> themes;  

  const SettingsState({this.themes});

  @override
  List<Object> get props => [];
}

class LoadingSettingsState extends SettingsState{
  LoadingSettingsState(List<String> themes)
    :super(themes: themes);
}

class InitialSettingsState extends SettingsState{
  InitialSettingsState(List<String> themes)
    :super(themes: themes);
}

class SuccessSettingsState extends SettingsState{
  final List<String> themes;
  
  const SuccessSettingsState(this.themes)
    :super(themes: themes);

  @override
  List<Object> get props => [themes];
}