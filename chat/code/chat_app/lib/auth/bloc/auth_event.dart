part of 'auth_bloc.dart';

// Abstract base class for authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event to check initial authentication state
class AuthStarted extends AuthEvent {}

// Event for sign-in request
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Event for sign-up request
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// Event for sign-out request
class AuthSignOutRequested extends AuthEvent {}

// Event to toggle between sign-in and sign-up modes
class AuthToggleMode extends AuthEvent {}