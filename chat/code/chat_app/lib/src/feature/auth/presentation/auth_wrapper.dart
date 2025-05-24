import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../../chat/bloc/chat_bloc.dart';
import 'login_screen.dart';
import '../../chat/presentation/chat_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return BlocProvider<ChatBloc>(
            create: (context) => getIt<ChatBloc>(),
            child: ChatScreen(user: state.user),
          );
        } else if (state is AuthUnauthenticated) {
          return const LoginScreen();
        } else if (state is AuthError) {
          return Scaffold(
            body: Center(child: Text('Error: ${state.message}')),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}