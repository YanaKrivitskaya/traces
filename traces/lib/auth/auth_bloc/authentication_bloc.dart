import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import '../repository/api_user_repository.dart';
import 'bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {  
  final ApiUserRepository _userRepository;

  AuthenticationBloc(): 
      _userRepository = new ApiUserRepository(),
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
        
        yield Authenticated(user, null);
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
