import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:traces/screens/settings/model/appSettings_entity.dart';
import 'package:traces/screens/settings/repository/appSettings_repository.dart';
import 'package:traces/screens/settings/repository/firebase_appSettings_repository.dart';
import 'dart:async';

part 'settings_state.dart';
part 'settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState>{
  final AppSettingsRepository _settingsRepository;
  //StreamSubscription _settingsSubscription;

  SettingsBloc({AppSettingsRepository settingsRepository})
  : _settingsRepository = settingsRepository ?? new FirebaseAppSettingsRepository(), 
      super(InitialSettingsState(null));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is GetAppSettings) {
      yield* _mapGetAppSettingsToState();
    }
  }

   Stream<SettingsState> _mapGetAppSettingsToState() async* {
     AppSettings settings;

    try{
      settings = await _settingsRepository.generalSettings();
      yield SuccessSettingsState(settings);

    }catch(e){
      print(e);
      //yield NoteState.failure(error: e.message);
    }    
  }
  
}

 