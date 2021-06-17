import 'package:meta/meta.dart';
import 'package:traces/auth/model/user.dart';
import 'package:traces/loginSignup/form_types.dart';
import 'package:traces/shared/state_types.dart';

@immutable
class LoginSignupState {
  final bool isEmailValid;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final StateStatus status;
  final FormMode form;
  final bool isPasswordReseted;
  final User user;
  final String errorMessage;

  bool get isSignupFormValid => isEmailValid & isPasswordValid & isUsernameValid;

  bool get isLoginFormValid => isEmailValid & isPasswordValid;

  LoginSignupState({
    @required this.isEmailValid,
    @required this.isUsernameValid,
    @required this.isPasswordValid,
    @required this.status,
    @required this.form,
    @required this.isPasswordReseted,
    this.user,
    this.errorMessage
  });

  factory LoginSignupState.empty(){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      status: StateStatus.Empty,
      form: FormMode.Login,
      isPasswordReseted: false,
      errorMessage: ""
    );
  }

  factory LoginSignupState.loading({FormMode formMode, bool isReseted}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      status: StateStatus.Loading,
      form: formMode,
      isPasswordReseted: isReseted
    );
  }

  factory LoginSignupState.success({FormMode formMode, bool isReseted, User user}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      status: StateStatus.Success,
      form: formMode,
      isPasswordReseted: isReseted,
      user: user
    );
  }

  factory LoginSignupState.failure({FormMode formMode, bool isReseted, String error}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      status: StateStatus.Error,
      form: formMode,
      isPasswordReseted: isReseted,
      errorMessage: error
    );
  }

  LoginSignupState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    StateStatus status,
    FormMode formMode,
    bool isPasswordReseted,
    String errorMessage
  }){
    return LoginSignupState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        status: status ?? this.status,
        form: formMode ?? this.form,
        isPasswordReseted: isPasswordReseted ?? this.isPasswordReseted,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  LoginSignupState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    FormMode formMode,
    bool isPasswordReseted,
    String errorMessage
  }){
    return copyWith(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isUsernameValid: isUsernameValid,
        status: StateStatus.Empty,
        formMode: formMode,
        isPasswordReseted: isPasswordReseted,
        errorMessage: errorMessage
    );
  }


  @override
  String toString(){
    return '''LoginSignupState{
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isUsernameValid: $isUsernameValid,
      status: $status,
      form: $form,
      isPasswordReseted: $isPasswordReseted,
      errorMessage: $errorMessage,
    }''';
  }

}

class InitialLoginSignupState extends LoginSignupState {}
