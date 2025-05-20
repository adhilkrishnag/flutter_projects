import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_repository.dart';
import 'dart:async';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated(isSignUp: false));
      }
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          add(_AuthStateChanged(user: user));
        } else {
          add(const _AuthStateChanged(user: null));
        }
      });
    });

    on<_AuthStateChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthAuthenticated(event.user!));
      } else {
        emit(AuthUnauthenticated(
            isSignUp: state is AuthUnauthenticated
                ? (state as AuthUnauthenticated).isSignUp
                : false));
      }
    });

    on<AuthSignUp>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signUp(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.signIn(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthSignOut>((event, emit) async {
      emit(AuthLoading());
      await authRepository.signOut();
      emit(const AuthUnauthenticated(isSignUp: false));
    });

    on<AuthToggleMode>((event, emit) {
      if (state is AuthUnauthenticated) {
        final currentState = state as AuthUnauthenticated;
        emit(AuthUnauthenticated(isSignUp: !currentState.isSignUp));
      }
    });

    @override
    // ignore: unused_element
    Future<void> close() {
      _authSubscription?.cancel();
      return super.close();
    }
  }
}
