import 'package:meta/meta.dart';

@immutable
abstract class LoginSignupEvent {
  const LoginSignupEvent();

  List<Object> get props => [];
}

class EmailChanged extends LoginSignupEvent{
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];
}

class UsernameChanged extends LoginSignupEvent{
  final String username;

  const UsernameChanged({@required this.username});

  @override
  List<Object> get props => [username];
}

class PasswordChanged extends LoginSignupEvent{
  final String password;

  const PasswordChanged({@required this.password});

  @override
  List<Object> get props => [password];
}

class SubmittedLogin extends LoginSignupEvent{
  final String email;
  final String password;

  const SubmittedLogin({
    @required this.email,
    @required this.password
  });

  @override
  List<Object> get props => [email, password];
}

class SubmittedSignup extends LoginSignupEvent{
  final String email;
  final String password;
  final String username;

  const SubmittedSignup({
    @required this.email,
    @required this.password,
    @required this.username
  });

  @override
  List<Object> get props => [email, password, username];
}

class SubmittedReset extends LoginSignupEvent{
  final String email;

  const SubmittedReset({@required this.email});

  @override
  List<Object> get props => [email];

}

class LoginPagePressed extends LoginSignupEvent{
  const LoginPagePressed();

  @override
  List<Object> get props => [];
}

class RegisterPagePressed extends LoginSignupEvent{
  const RegisterPagePressed();

  @override
  List<Object> get props => [];
}

class ResetPagePressed extends LoginSignupEvent{
  const ResetPagePressed();

  @override
  List<Object> get props => [];
}
