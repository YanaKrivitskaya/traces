part of 'settings_bloc.dart';

abstract class ThemeSettingsState{ 
  final AppTheme? userTheme;

  const ThemeSettingsState({this.userTheme});

  @override
  List<Object?> get props => [];
}

class LoadingSettingsState extends ThemeSettingsState{}

class InitialSettingsState extends ThemeSettingsState{}

class SuccessSettingsState extends ThemeSettingsState{  
  final AppTheme? selectedTheme;
  final AppTheme? userTheme;
  
  const SuccessSettingsState(this.selectedTheme, this.userTheme)
    :super(userTheme: userTheme);

  @override
  List<Object?> get props => [selectedTheme, userTheme];
}