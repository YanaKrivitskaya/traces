part of 'settings_bloc.dart';

abstract class SettingsState{ 
  final AppTheme? userTheme;

  const SettingsState({this.userTheme});

  @override
  List<Object?> get props => [];
}

class LoadingSettingsState extends SettingsState{}

class InitialSettingsState extends SettingsState{}

class SuccessSettingsState extends SettingsState{  
  final AppTheme? selectedTheme;
  final AppTheme? userTheme;
  
  const SuccessSettingsState(this.selectedTheme, this.userTheme)
    :super(userTheme: userTheme);

  @override
  List<Object?> get props => [selectedTheme, userTheme];
}