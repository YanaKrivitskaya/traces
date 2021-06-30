import 'package:equatable/equatable.dart';
import 'package:traces/auth/model/account.model.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthenticationEvent{
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent{
  final Account? user;

  LoggedIn(this.user);

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}
