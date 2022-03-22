import 'package:meta/meta.dart';

import '../../../utils/misc/state_types.dart';
import '../../model/account.model.dart';

@immutable 
abstract class LoginState{
  final String? email;

  const LoginState(this.email);

   @override
  List<Object?> get props => [email];
}

class LoginStateInitial extends LoginState{
   LoginStateInitial(String? email) : super(email);
}

class LoginStateEdit extends LoginState{
  final String email;
  final bool isEmailValid;

  LoginStateEdit(this.email, this.isEmailValid) : super(email);

  @override
  List<Object?> get props => [email, isEmailValid];
}

class LoginStateSuccess extends LoginState{
  final String email;

  LoginStateSuccess(this.email) : super(email);

  @override
  List<Object?> get props => [email];
}

class LoginStateError extends LoginState{  
  final String error;

  LoginStateError(String? email, this.error) : super(email);

  @override
  List<Object?> get props => [email, error];
}

class LoginStateLoading extends LoginState{
   LoginStateLoading(String? email) : super(email);
}

/*@immutable
class LoginSignupState {
  final bool isEmailValid;
  final StateStatus status;
  final Account? user;
  final String? errorMessage;

  LoginSignupState({
    required this.isEmailValid,
    required this.status,
    this.user,
    this.errorMessage
  });

  factory LoginSignupState.empty(){
    return LoginSignupState(
      isEmailValid: true,
      status: StateStatus.Empty,
      errorMessage: ""
    );
  }

  factory LoginSignupState.loading({bool? isReseted}){
    return LoginSignupState(
      isEmailValid: true,
      status: StateStatus.Loading,
    );
  }

  factory LoginSignupState.success({bool? isReseted, Account? user}){
    return LoginSignupState(
      isEmailValid: true,
      status: StateStatus.Success,
      user: user
    );
  }

  factory LoginSignupState.failure({bool? isReseted, String? error}){
    return LoginSignupState(
      isEmailValid: true,
      status: StateStatus.Error,
      errorMessage: error
    );
  }

  LoginSignupState copyWith({
    bool? isEmailValid,
    StateStatus? status,
    String? errorMessage
  }){
    return LoginSignupState(
        isEmailValid: isEmailValid ?? this.isEmailValid,        
        status: status ?? this.status,       
        errorMessage: errorMessage ?? this.errorMessage
    );
  }

  LoginSignupState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isUsernameValid,
    bool? isPasswordReseted,
    String? errorMessage
  }){
    return copyWith(
        isEmailValid: isEmailValid,
        status: StateStatus.Empty,
        errorMessage: errorMessage
    );
  }


  @override
  String toString(){
    return '''LoginSignupState{
      isEmailValid: $isEmailValid,
      status: $status,
      errorMessage: $errorMessage,
    }''';
  }

}

mixin InitialLoginSignupState implements LoginSignupState {}*/
