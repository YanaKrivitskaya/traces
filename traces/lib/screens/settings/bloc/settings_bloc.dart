import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/settings/repository/appSettings_repository.dart';
import 'package:traces/screens/settings/repository/firebase_appSettings_repository.dart';
import 'dart:async';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  final AppSettingsRepository _settingsRepository;
  StreamSubscription _settingsSubscription;

  SettingsBloc({AppSettingsRepository settingsRepository})
  : _settingsRepository = settingsRepository ?? new FirebaseAppSettingsRepository(), 
      super(InitialSettingsState(null));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetThemes) {
      yield* _mapGetThemesToState();
    } else if (event is UpdateThemesList) {
      yield* _mapUpdateThemesListToState(event);
    }
  }

  Stream<SettingsState> _mapUpdateThemesListToState(UpdateThemesList event) async* {
    yield SuccessSettingsState(event.themes);
  }

   Stream<SettingsState> _mapGetThemesToState() async* {
    _settingsSubscription?.cancel();    

    try{
      /*_settingsSubscription = _settingsRepository.appThemes().listen(
            (themes) => add(UpdateThemesList(themes))
      );*/
    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }

  }
  
}

 