import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../model/appSettings_entity.dart';
import '../repository/appSettings_repository.dart';
import '../repository/firebase_appSettings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  //final AppSettingsRepository _settingsRepository;  

  SettingsBloc(/*{AppSettingsRepository? settingsRepository}*/)
  : /*_settingsRepository = settingsRepository ?? new FirebaseAppSettingsRepository(),*/
      super(InitialSettingsState(null));

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
     AppSettings settings;

    try{
      /*settings = await _settingsRepository.generalSettings();
      var userSettings = await _settingsRepository.userSettings();   
      yield SuccessSettingsState(settings, null, userSettings.theme);*/

    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }    
  }

  Stream<SettingsState> _mapThemeSelectedToState(String? theme) async* {
     yield SuccessSettingsState(state.settings, theme, state.userTheme);
  }

  Stream<SettingsState> _mapSubmitThemeToState(String? theme) async* {
    /*var settings = await _settingsRepository.userSettings();
    settings.theme = theme;

    await _settingsRepository.updateUserSettings(settings);*/

     yield SuccessSettingsState(null, null, null/*state.settings, theme, theme*/);
  }

  Stream<SettingsState> _mapGetUserSettingsToState() async* {
    //var settings = await _settingsRepository.userSettings();   

     yield SuccessSettingsState(null, null, null/*settings.theme*/);
  }
  
}

 