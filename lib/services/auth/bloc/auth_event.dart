import 'package:flutter/foundation.dart' show immutable;

//defining classes with their constructor
@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

//define a class AuthEventLogOut with two properties (email and password)
class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}
