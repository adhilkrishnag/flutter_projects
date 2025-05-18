import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

// BLoC for managing authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    // Register event handlers
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthToggleMode>(_onToggleMode);
  }

  // Handle initial authentication state check
  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  // Handle sign-in request
  Future<void> _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signIn(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError('Sign-in failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle sign-up request
  Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUp(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError('Sign-up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Handle sign-out request
  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await authRepository.signOut();
    emit(const AuthUnauthenticated());
  }

  // Handle toggling between sign-in and sign-up modes
  void _onToggleMode(AuthToggleMode event, Emitter<AuthState> emit) {
    if (state is AuthUnauthenticated) {
      final currentState = state as AuthUnauthenticated;
      emit(AuthUnauthenticated(isSignUp: !currentState.isSignUp));
    }
  }
}