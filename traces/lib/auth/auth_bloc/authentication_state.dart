import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:traces/auth/model/account.model.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState{
  final Account? user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];

  @override
  String toString() => 'Authenticated { user: ${user.toString()} }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}


