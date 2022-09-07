import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:traces/screens/settings/model/app_menu.dart';
import 'package:traces/screens/settings/model/app_theme.dart';
import 'package:traces/utils/services/shared_preferencies_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState>{
  SharedPreferencesService sharedPrefsService = SharedPreferencesService();

  AppSettingsBloc():
      super(InitialSettingsState()){
        on<GetAppSettings>(_onGetAppSettings);
        on<ThemeSelected>(_onThemeSelected);
        on<SubmitTheme>(_onSubmitTheme);
        on<MenuSelected>(_onMenuSelected);
        on<SubmitMenu>(_onSubmitMenu);
      }

  void _onGetAppSettings(GetAppSettings event, Emitter<AppSettingsState> emit) async{
    try{
      var theme = sharedPrefsService.readString(key: "appTheme");
      var menu = sharedPrefsService.readString(key: "appMenu");
      var userTheme = AppThemes.first;
      var userMenu = AppMenues.first;
      if(theme != null){
        userTheme = AppThemes.firstWhere((t) => t.name == theme);        
      }
      if(menu != null){
        userMenu = AppMenues.firstWhere((t) => t.name == menu);        
      }
      return emit(SuccessSettingsState(userTheme, userTheme, userMenu, userMenu));
    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }
  }
  
  void _onThemeSelected(ThemeSelected event, Emitter<AppSettingsState> emit) async{
     return emit(SuccessSettingsState(event.theme, state.userTheme, state.userMenu, state.userMenu));
  }  

  void _onMenuSelected(MenuSelected event, Emitter<AppSettingsState> emit) async{
     return emit(SuccessSettingsState(state.userTheme, state.userTheme, state.userMenu, event.menu));
  }

  void _onSubmitTheme(SubmitTheme event, Emitter<AppSettingsState> emit) async{
    await sharedPrefsService.writeString(key: "appTheme", value: event.theme.name);
     return emit(SuccessSettingsState(event.theme, event.theme, state.userMenu, state.userMenu));
  }

  void _onSubmitMenu(SubmitMenu event, Emitter<AppSettingsState> emit) async{
    await sharedPrefsService.writeString(key: "appMenu", value: event.menu.name);
     return emit(SuccessSettingsState(state.userTheme, state.userTheme, event.menu, event.menu));
  }
}

 