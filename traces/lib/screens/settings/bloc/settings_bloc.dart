import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();

  SettingsBloc():
      super(InitialSettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetAppSettings) {
      yield* _mapGetAppSettingsToState();
    } else if (event is ThemeSelected) {
      yield* _mapThemeSelectedToState(event.theme);
    }else if (event is SubmitTheme) {
      yield* _mapSubmitThemeToState(event.theme);
    }
  }

   Stream<SettingsState> _mapGetAppSettingsToState() async* {     

    try{
      var theme = sharedPrefsService.readString(key: "appTheme");
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
    await sharedPrefsService.writeString(key: "appTheme", value: theme.name);

     yield SuccessSettingsState(theme, theme);
  }  
}

 