import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:traces/auth/model/user.model.dart';
import 'package:traces/screens/settings/model/appUserSettings_entity.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState{
  final User user;
  final AppUserSettings userSettings;

  const Authenticated(this.user, this.userSettings);

  @override
  List<Object> get props => [user, userSettings];

  @override
  String toString() => 'Authenticated { user: ${user.toString()} }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}


