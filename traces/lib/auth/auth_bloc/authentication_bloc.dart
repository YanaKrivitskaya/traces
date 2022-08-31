import 'package:bloc/bloc.dart';
import 'package:traces/auth/repository/mock_user_repository.dart';
import 'package:traces/auth/repository/userRepository.dart';
import '../repository/api_user_repository.dart';
import 'bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {  
  final UserRepository _userRepository;

  AuthenticationBloc():       
      _userRepository = const String.fromEnvironment("mode") == "test" ? new MockUserRepository() : new ApiUserRepository(),
      super(Uninitialized()){
        on<AppStarted>(_onAppStarted);
        on<LoggedIn>(_onLoggedIn);
        on<LoggedOut>(_onLoggedOut);

      }

  void _onAppStarted(AppStarted event, Emitter<AuthenticationState> emit) async{
    try{
      final user = await _userRepository.getAccessToken();
      if(user.id != null){
        return emit(Authenticated(user));
      }else return emit(Unauthenticated());
    }catch(_){
      return emit(Unauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthenticationState> emit)async{
    return emit(Authenticated(event.user));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthenticationState> emit)async{
    await _userRepository.signOut();

    return emit(Unauthenticated());
  }
}
