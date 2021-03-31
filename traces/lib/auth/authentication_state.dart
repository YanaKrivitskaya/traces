import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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
  final String uid;
  final AppUserSettings userSettings;

  const Authenticated(this.uid, this.userSettings);

  @override
  List<Object> get props => [uid, userSettings];

  @override
  String toString() => 'Authenticated { displayName: $uid }';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}


