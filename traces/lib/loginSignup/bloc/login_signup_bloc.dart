import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/loginSignup/validator.dart';
import 'package:rxdart/rxdart.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> {
  UserRepository _userRepository;

  LoginSignupBloc({
    @required UserRepository userRepository
  }) : assert (userRepository != null),
      _userRepository = userRepository;

  @override
  LoginSignupState get initialState => LoginSignupState.empty();

  @override
  Stream<Transition<LoginSignupEvent, LoginSignupState>> transformEvents(
      Stream<LoginSignupEvent> events,
      TransitionFunction<LoginSignupEvent, LoginSignupState> transitionFn,
      ) {
    final nonDebounceStream = events.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = events.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginSignupState> mapEventToState(
    LoginSignupEvent event,
  ) async* {
    if(event is EmailChanged){
      yield* _mapEmailChangedToState(event.email);
    }else if (event is PasswordChanged){
      yield* _mapPasswordChangedToState(event.password);
    }else if (event is UsernameChanged){
      yield* _mapUsernameChangedToState(event.username);
    }else if (event is SubmittedLogin){
      yield* _mapLoginWithCredentialsPressedToState(email: event.email, password: event.password);
    }else if(event is SubmittedSignup){
      yield* _mapSignupPressedToState(email: event.email, password: event.password, username: event.username);
    }else if(event is SubmittedReset){
      yield* _mapPasswordResetedToState(email: event.email);
    }else if(event is LoginPagePressed){
      yield* _mapLoginPagePressedToState(event.isLoginForm);
    }else if(event is RegisterPagePressed){
      yield* _mapRegisterPagePressedToState(event.isRegisterForm);
    }else if(event is ResetPagePressed){
      yield* _mapResetPagePressedToState(event.isResetForm);
    }
  }

  Stream<LoginSignupState> _mapEmailChangedToState(String email) async*{
    yield state.update(
        isEmailValid: LoginSignupValidator.isValidEmail(email)
    );
  }

  Stream<LoginSignupState> _mapPasswordChangedToState(String password) async*{
    yield state.update(
        isPasswordValid: LoginSignupValidator.isValidPassword(password)
    );
  }

  Stream<LoginSignupState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isPasswordValid: LoginSignupValidator.isValidUsername(username)
    );
  }

  Stream<LoginSignupState> _mapLoginPagePressedToState(bool isLoginForm) async*{
    yield state.update(
      isLoginForm: isLoginForm,
      isRegisterForm: false,
      isResetForm: false,
      isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapRegisterPagePressedToState(bool isResetForm) async*{
    yield state.update(
        isLoginForm: false,
        isRegisterForm: isResetForm,
        isResetForm: false,
        isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapResetPagePressedToState(bool isResetForm) async*{
    yield state.update(
        isLoginForm: false,
        isRegisterForm: false,
        isResetForm: isResetForm,
        isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password
  }) async*{
    yield LoginSignupState.loading(
      isLogin: true,
      isRegister: false,
      isReset: false,
      isReseted: false
    );
    try{
      await _userRepository.signInWithEmailAndPassword(email, password);
      yield LoginSignupState.success(
          isLogin: true,
          isRegister: false,
          isReset: false,
          isReseted: false
      );
    } catch(e){
      yield LoginSignupState.failure(
          isLogin: true,
          isRegister: false,
          isReset: false,
          isReseted: false,
          error: e.message);
    }
  }

  Stream<LoginSignupState> _mapSignupPressedToState({
    String email,
    String password,
    String username
  }) async*{
    yield LoginSignupState.loading(
        isLogin: false,
        isRegister: true,
        isReset: false,
        isReseted: false
    );
    try{
      await _userRepository.signUp(email, password, username);
      yield LoginSignupState.success(
          isLogin: false,
          isRegister: true,
          isReset: false,
          isReseted: false
      );
    } catch(e){
      yield LoginSignupState.failure(
          isLogin: false,
          isRegister: true,
          isReset: false,
          isReseted: false,
          error: e.message);
    }
  }

  Stream<LoginSignupState> _mapPasswordResetedToState({
    String email
  }) async*{
    yield LoginSignupState.loading(
        isLogin: false,
        isRegister: false,
        isReset: true,
        isReseted: false
    );
    try{
      await _userRepository.resetPassword(email);
      yield state.update(
          isLoginForm: false,
          isRegisterForm: false,
          isResetForm: true,
          isPasswordReseted: true
      );
    }catch(e){
      yield LoginSignupState.failure(
          isLogin: false,
          isRegister: false,
          isReset: true,
          isReseted: false,
          error: e.message);
    }
  }
}
