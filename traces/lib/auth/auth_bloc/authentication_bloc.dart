import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../screens/settings/repository/appSettings_repository.dart';
import '../../screens/settings/repository/firebase_appSettings_repository.dart';
import '../repository/api_user_repository.dart';
import 'bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  final ApiUserRepository _userRepository;
  final AppSettingsRepository _appSettingsRepository;

  AuthenticationBloc(): 
      _userRepository = new ApiUserRepository(),
      _appSettingsRepository = new FirebaseAppSettingsRepository(),
      super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is AppStarted) yield* _mapAppStartedToState();
    else if(event is LoggedIn) yield* _mapLoggedInToState(event);
    else if(event is LoggedOut) yield* _mapLoggedOutToState();
  }

  Stream<AuthenticationState> _mapAppStartedToState() async*{
    await Firebase.initializeApp();

    try{
      final user = await _userRepository.getAccessToken();
      if(user != null){        
        //final userSettings = await _appSettingsRepository.userSettings();
        yield Authenticated(user/*, userSettings*/, null);
      }else yield Unauthenticated();
    }catch(_){
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(event) async*{
    yield Authenticated(event.user, /*await _appSettingsRepository.userSettings()*/null);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
}
}
