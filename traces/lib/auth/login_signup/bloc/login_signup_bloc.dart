import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:traces/auth/model/login.model.dart';
import 'package:traces/auth/model/account.model.dart';
import 'package:traces/auth/repository/api_user_repository.dart';
import 'package:traces/utils/api/customException.dart';
import 'package:traces/utils/helpers/validation_helper.dart';

import '../form_types.dart';
import 'bloc.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> { 
  ApiUserRepository _apiUserRepository;

  LoginSignupBloc():      
      _apiUserRepository = new ApiUserRepository(),
      super(LoginSignupState.empty());

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
        isEmailValid: Validator.isValidEmail(email)
    );
  }

  Stream<LoginSignupState> _mapPasswordChangedToState(String password) async*{
    yield state.update(
        isPasswordValid: Validator.isValidPassword(password)
    );
  }

  Stream<LoginSignupState> _mapUsernameChangedToState(String username) async*{
    yield state.update(
        isPasswordValid: Validator.isValidUsername(username)
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
    required String email,
    required String password
  }) async*{
    yield LoginSignupState.loading(
      formMode: FormMode.Login,
      isReseted: false
    );
    LoginModel loginModel = LoginModel(email: email, password: password);
    try{
      await _apiUserRepository.signInWithEmailAndPassword(loginModel);
      yield LoginSignupState.success(
          formMode: FormMode.Login,
          isReseted: false
      );
    } on CustomException catch(e){      
      yield LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString());
    }

  }

  Stream<LoginSignupState> _mapSignupPressedToState({
    required String email,
    required String password,
    required String username
  }) async*{
    yield LoginSignupState.loading(
        formMode: FormMode.Register,
        isReseted: false
    );
    try{
      final user = Account(
        name: username,
        email: email,
        password: password
      );

      await _apiUserRepository.signUp(user);

      LoginModel loginModel = LoginModel(email: email, password: password);

      await _apiUserRepository.signInWithEmailAndPassword(loginModel);

      yield LoginSignupState.success(
          formMode: FormMode.Register,
          isReseted: false
      );
    } on CustomException catch(e){      
      yield LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString());
    }on Exception catch(e){      
      yield LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString());
    }
  }

  Stream<LoginSignupState> _mapPasswordResetedToState({
    required String email
  }) async*{
    yield LoginSignupState.loading(
        formMode: FormMode.Reset,
        isReseted: false
    );
    try{
      //await _userRepository.resetPassword(email);
      yield state.update(
          formMode: FormMode.Reset,
          isPasswordReseted: true
      );
    } on CustomException catch(e){
      yield LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString());
    }
  }
}
