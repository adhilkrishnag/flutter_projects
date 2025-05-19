import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/bloc/auth_bloc.dart';
import '../chat/bloc/chat_bloc.dart';
import '../chat/chat_repository.dart';
import 'login_screen.dart';
import 'chat_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              chatRepository: RepositoryProvider.of<ChatRepository>(context),
            )..add(ChatLoadMessages()),
            child: ChatScreen(user: state.user),
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}