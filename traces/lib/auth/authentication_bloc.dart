import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
    : assert (userRepository != null),
      _userRepository = userRepository, super(Uninitialized());

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
        yield Authenticated(uid);
      }else yield Unauthenticated();
    }catch(_){
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async*{
    yield Authenticated(await _userRepository.getUserId());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
}
}
