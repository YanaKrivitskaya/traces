import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/screens/settings/repository/appSettings_repository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final UserRepository _userRepository;
  final AppSettingsRepository _appSettingsRepository;

  AuthenticationBloc({@required UserRepository userRepository, @required AppSettingsRepository settingsRepository})
    : assert (userRepository != null),
      _userRepository = userRepository, 
      _appSettingsRepository = settingsRepository,
      super(Uninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if(event is AppStarted) yield* _mapAppStartedToState();
    else if(event is LoggedIn) yield* _mapLoggedInToState();
    else if(event is LoggedOut) yield* _mapLoggedOutToState();
  }

  Stream<AuthenticationState> _mapAppStartedToState() async*{
    await Firebase.initializeApp();

    try{
      final isSignedIn = await _userRepository.isSignedIn();
      if(isSignedIn){
        final uid = await _userRepository.getUserId();
        final userSettings = await _appSettingsRepository.userSettings();
        yield Authenticated(uid, userSettings);
      }else yield Unauthenticated();
    }catch(_){
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async*{
    yield Authenticated(await _userRepository.getUserId(), await _appSettingsRepository.userSettings());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
}
}
