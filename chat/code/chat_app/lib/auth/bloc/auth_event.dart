part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class _AuthStateChanged extends AuthEvent {
  final User? user;
  const _AuthStateChanged({this.user});
  @override
  List<Object> get props => [user ?? ''];
}

class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  const AuthSignUp({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthSignIn extends AuthEvent {
  final String email;
  final String password;
  const AuthSignIn({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class AuthSignOut extends AuthEvent {}

class AuthToggleMode extends AuthEvent {}
