import 'package:meta/meta.dart';

@immutable
class LoginSignupState {
  final bool isEmailValid;
  final bool isUsernameValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isLoginForm;
  final bool isRegisterForm;
  final bool isResetForm;
  final bool isPasswordReseted;
  final String errorMessage;

  bool get isSignupFormValid => isEmailValid & isPasswordValid & isUsernameValid;

  bool get isLoginFormValid => isEmailValid & isPasswordValid;

  LoginSignupState({
    @required this.isEmailValid,
    @required this.isUsernameValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isLoginForm,
    @required this.isRegisterForm,
    @required this.isResetForm,
    @required this.isPasswordReseted,
    this.errorMessage
  });

  factory LoginSignupState.empty(){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isLoginForm: true,
      isRegisterForm: false,
      isResetForm: false,
      isPasswordReseted: false,
      errorMessage: ""
    );
  }

  factory LoginSignupState.loading({bool isLogin, bool isRegister, bool isReset, bool isReseted}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isLoginForm: isLogin,
      isRegisterForm: isRegister,
      isResetForm: isReset,
      isPasswordReseted: isReseted
    );
  }

  factory LoginSignupState.success({bool isLogin, bool isRegister, bool isReset, bool isReseted}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isLoginForm: isLogin,
      isRegisterForm: isRegister,
      isResetForm: isReset,
      isPasswordReseted: isReseted
    );
  }

  factory LoginSignupState.failure({bool isLogin, bool isRegister, bool isReset, bool isReseted, String error}){
    return LoginSignupState(
      isEmailValid: true,
      isPasswordValid: true,
      isUsernameValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isLoginForm: isLogin,
      isRegisterForm: isRegister,
      isResetForm: isReset,
      isPasswordReseted: isReseted,
      errorMessage: error
    );
  }

  LoginSignupState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isLoginFrom,
    bool isRegisterForm,
    bool isResetForm,
    bool isPasswordReseted,
    String errorMessage
  }){
    return LoginSignupState(
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isUsernameValid: isUsernameValid ?? this.isUsernameValid,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        isLoginForm: isLoginFrom ?? this.isLoginForm,
        isRegisterForm: isRegisterForm ?? this.isRegisterForm,
        isResetForm: isResetForm ?? this.isResetForm,
        isPasswordReseted: isPasswordReseted ?? this.isPasswordReseted,
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  LoginSignupState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUsernameValid,
    bool isLoginForm,
    bool isRegisterForm,
    bool isResetForm,
    bool isPasswordReseted,
    String errorMessage
  }){
    return copyWith(
        isEmailValid: isEmailValid,
        isPasswordValid: isPasswordValid,
        isUsernameValid: isUsernameValid,
        isSubmitting: false,
        isFailure: false,
        isSuccess: false,
        isLoginFrom: isLoginForm,
        isRegisterForm: isRegisterForm,
        isResetForm: isResetForm,
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
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isLoginFrom: $isLoginForm,
      isRegisterForm: $isRegisterForm,
      isResetForm: $isResetForm,
      isPasswordReseted: $isPasswordReseted,
      errorMessage: $errorMessage,
    }''';
  }

}

class InitialLoginSignupState extends LoginSignupState {}
