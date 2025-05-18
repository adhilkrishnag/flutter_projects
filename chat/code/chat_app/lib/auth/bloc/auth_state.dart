part of 'auth_bloc.dart';

// Abstract base class for authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Initial state before authentication check
class AuthInitial extends AuthState {}

// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final dynamic user; // Using dynamic to avoid Firebase User dependency

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  final bool isSignUp;

  const AuthUnauthenticated({this.isSignUp = false});

  @override
  List<Object> get props => [isSignUp];
}

// State during authentication operations
class AuthLoading extends AuthState {}

// State when an authentication error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}