import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();

  SettingsBloc():
      super(InitialSettingsState()){
        on<GetAppSettings>(_onGetAppSettings);
        on<ThemeSelected>(_onThemeSelected);
        on<SubmitTheme>(_onSubmitTheme);
      }

  void _onGetAppSettings(GetAppSettings event, Emitter<SettingsState> emit) async{
    try{
      var theme = sharedPrefsService.readString(key: "appTheme");
      if(theme != null){
        var userTheme = AppThemes.firstWhere((t) => t.name == theme);
        return emit(SuccessSettingsState(userTheme, userTheme));
      }else{
        return emit(SuccessSettingsState(AppThemes.first, AppThemes.first));
      }
    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }
  }
  void _onThemeSelected(ThemeSelected event, Emitter<SettingsState> emit) async{
     return emit(SuccessSettingsState(event.theme, state.userTheme));
  }  

  void _onSubmitTheme(SubmitTheme event, Emitter<SettingsState> emit) async{
    await sharedPrefsService.writeString(key: "appTheme", value: event.theme.name);
     return emit(SuccessSettingsState(event.theme, event.theme));
  }
}

 