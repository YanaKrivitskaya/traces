import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();
  //final AppSettingsRepository _settingsRepository;  

  SettingsBloc(/*{AppSettingsRepository? settingsRepository}*/)
  : /*_settingsRepository = settingsRepository ?? new FirebaseAppSettingsRepository(),*/
      super(InitialSettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetAppSettings) {
      yield* _mapGetAppSettingsToState();
    } else if (event is ThemeSelected) {
      yield* _mapThemeSelectedToState(event.theme);
    }else if (event is SubmitTheme) {
      yield* _mapSubmitThemeToState(event.theme);
    }else if (event is GetUserSettings) {
      yield* _mapGetUserSettingsToState();
    }
  }

   Stream<SettingsState> _mapGetAppSettingsToState() async* {     

    try{
      var theme = sharedPrefsService.read(key: "appTheme");
      if(theme != null){
        var userTheme = AppThemes.firstWhere((t) => t.name == theme);
        yield SuccessSettingsState(userTheme, userTheme);
      }else{
        yield SuccessSettingsState(AppThemes.first, AppThemes.first);
      }
    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }    
  }

  Stream<SettingsState> _mapThemeSelectedToState(AppTheme? theme) async* {
     yield SuccessSettingsState(theme, state.userTheme);
  }

  Stream<SettingsState> _mapSubmitThemeToState(AppTheme theme) async* {
    await sharedPrefsService.write(key: "appTheme", value: theme.name);
    /*var settings = await _settingsRepository.userSettings();
    settings.theme = theme;

    await _settingsRepository.updateUserSettings(settings);*/

     yield SuccessSettingsState(theme, theme);
  }

  Stream<SettingsState> _mapGetUserSettingsToState() async* {
    var theme = sharedPrefsService.read(key: "appTheme");

     //yield SuccessSettingsState(null, theme);
  }
  
}

 