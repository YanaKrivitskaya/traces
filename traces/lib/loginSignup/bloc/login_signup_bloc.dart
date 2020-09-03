import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:traces/auth/userRepository.dart';
import 'package:traces/loginSignup/form_types.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:traces/loginSignup/validator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> {
  UserRepository _userRepository;

  LoginSignupBloc({@required UserRepository userRepository}) : assert (userRepository != null),
      _userRepository = userRepository, super(LoginSignupState.empty());

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
      yield* _mapLoginPagePressedToState();
    }else if(event is RegisterPagePressed){
      yield* _mapRegisterPagePressedToState();
    }else if(event is ResetPagePressed){
      yield* _mapResetPagePressedToState();
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

  Stream<LoginSignupState> _mapLoginPagePressedToState() async*{
    yield state.update(
      formMode: FormMode.Login,
      isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapRegisterPagePressedToState() async*{
    yield state.update(
        formMode: FormMode.Register,
        isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapResetPagePressedToState() async*{
    yield state.update(
        formMode: FormMode.Reset,
        isPasswordReseted: false
    );
  }

  Stream<LoginSignupState> _mapLoginWithCredentialsPressedToState({
    String email,
    String password
  }) async*{
    yield LoginSignupState.loading(
      formMode: FormMode.Login,
      isReseted: false
    );
    try{
      await _userRepository.signInWithEmailAndPassword(email, password);
      yield LoginSignupState.success(
          formMode: FormMode.Login,
          isReseted: false
      );
    } on FirebaseAuthException catch(e){
      yield LoginSignupState.failure(
          formMode: FormMode.Login,
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
        formMode: FormMode.Register,
        isReseted: false
    );
    try{
      await _userRepository.signUp(email, password, username);

      yield LoginSignupState.success(
          formMode: FormMode.Register,
          isReseted: false
      );
    } on FirebaseAuthException catch(e){
      yield LoginSignupState.failure(
          formMode: FormMode.Register,
          isReseted: false,
          error: e.message);
    }
  }

  Stream<LoginSignupState> _mapPasswordResetedToState({
    String email
  }) async*{
    yield LoginSignupState.loading(
        formMode: FormMode.Reset,
        isReseted: false
    );
    try{
      await _userRepository.resetPassword(email);
      yield state.update(
          formMode: FormMode.Reset,
          isPasswordReseted: true
      );
    } on FirebaseAuthException catch(e){
      yield LoginSignupState.failure(
          formMode: FormMode.Reset,
          isReseted: false,
          error: e.message);
    }
  }
}
