import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import 'login_screen.dart';
import 'chat_screen.dart';

// Wrapper widget to decide between login and chat screens
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return ChatScreen(user: state.user);
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
