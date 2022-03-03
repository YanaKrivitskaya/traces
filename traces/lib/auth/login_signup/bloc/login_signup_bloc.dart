import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/api/customException.dart';
import '../../../utils/helpers/validation_helper.dart';
import '../../model/account.model.dart';
import '../../model/login.model.dart';
import '../../repository/api_user_repository.dart';
import '../form_types.dart';
import 'bloc.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> { 
  ApiUserRepository _apiUserRepository;

  /// Define a custom `EventTransformer`
  EventTransformer<LoginSignupEvent> debounce<LoginSignupEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  LoginSignupBloc():      
      _apiUserRepository = new ApiUserRepository(),
      super(LoginSignupState.empty()){
        /// Apply the custom `EventTransformer` to the `EventHandler`
        on<EmailChanged>(_onEmailChanged, transformer: debounce(Duration(milliseconds: 500)));
        on<PasswordChanged>(_onPasswordChanged, transformer: debounce(Duration(milliseconds: 500)));
        on<UsernameChanged>(_onUsernameChanged, transformer: debounce(Duration(milliseconds: 500)));
        on<LoginPagePressed>(_onLoginPage);
        on<RegisterPagePressed>(_onRegisterPage);
        on<ResetPagePressed>(_onResetPage);
        on<SubmittedLogin>(_onLoginWithCredentials);
        on<SubmittedSignup>(_onSignUp);
        on<SubmittedReset>(_onReset);
      }

  void _onEmailChanged(EmailChanged event, Emitter<LoginSignupState> emit) async{
    return emit(state.update(isEmailValid: Validator.isValidEmail(event.email)));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginSignupState> emit) async{
    return emit(state.update(isPasswordValid: Validator.isValidPassword(event.password)));
  }

  void _onUsernameChanged(UsernameChanged event, Emitter<LoginSignupState> emit) async{
    return emit(state.update(isUsernameValid: Validator.isValidUsername(event.username)));
  }

  void _onLoginPage(LoginPagePressed event, Emitter<LoginSignupState> emit) async{
    return emit(
      state.update(
        formMode: FormMode.Login,
        isPasswordReseted: false
      )
    );
  }

  void _onRegisterPage(RegisterPagePressed event, Emitter<LoginSignupState> emit) async{
    return emit(
      state.update(
        formMode: FormMode.Register,
        isPasswordReseted: false
      )
    );
  }

  void _onResetPage(ResetPagePressed event, Emitter<LoginSignupState> emit) async{
    return emit(
      state.update(
        formMode: FormMode.Reset,
        isPasswordReseted: false
      )
    );
  }

  void _onLoginWithCredentials(SubmittedLogin event, Emitter<LoginSignupState> emit)async{
    emit(LoginSignupState.loading(
        formMode: FormMode.Login,
        isReseted: false
    ));
    LoginModel loginModel = LoginModel(email: event.email, password: event.password);
    try{
      await _apiUserRepository.signInWithEmailAndPassword(loginModel);
      return emit(LoginSignupState.success(
          formMode: FormMode.Login,
          isReseted: false
      ));
    } on CustomException catch(e){      
      return emit (LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString()));
    }
  }

  void _onSignUp(SubmittedSignup event, Emitter<LoginSignupState> emit)async{
    emit(LoginSignupState.loading(
        formMode: FormMode.Register,
        isReseted: false
    ));
    
    try{
      final user = Account(
        name: event.username,
        email: event.email,
        password: event.password
      );

      await _apiUserRepository.signUp(user);

      LoginModel loginModel = LoginModel(email: event.email, password: event.password);

      await _apiUserRepository.signInWithEmailAndPassword(loginModel);

      return emit( LoginSignupState.success(
          formMode: FormMode.Register,
          isReseted: false
      ));
    } on CustomException catch(e){      
      return emit(LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString()));
    }on Exception catch(e){      
      return emit(LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString()));
    }
  }

  void _onReset(SubmittedReset event, Emitter<LoginSignupState> emit)async{
    emit(LoginSignupState.loading(
        formMode: FormMode.Reset,
        isReseted: false
    ));
    try{
      //await _userRepository.resetPassword(email);
      return emit(state.update(
          formMode: FormMode.Reset,
          isPasswordReseted: true
      ));
    } on CustomException catch(e){
      return emit(LoginSignupState.failure(
          formMode: FormMode.Login,
          isReseted: false,
          error: e.toString()));
    }
  }  
}
