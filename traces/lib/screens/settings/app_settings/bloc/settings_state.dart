part of 'settings_bloc.dart';

abstract class AppSettingsState{ 
  final AppTheme? userTheme;
  final AppMenu? userMenu;

  const AppSettingsState({this.userTheme, this.userMenu});

  @override
  List<Object?> get props => [];
}

class LoadingSettingsState extends AppSettingsState{}

class InitialSettingsState extends AppSettingsState{}

class SuccessSettingsState extends AppSettingsState{  
  final AppTheme? selectedTheme;
  final AppTheme? userTheme;
  final AppMenu? userMenu;
  final AppMenu? selectedMenu;
  
  const SuccessSettingsState(this.selectedTheme, this.userTheme, this.userMenu, this.selectedMenu)
    :super(userTheme: userTheme, userMenu: userMenu);

  @override
  List<Object?> get props => [selectedTheme, userTheme, userMenu, selectedMenu];
}