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
          try {
            return BlocProvider<ChatBloc>(
              create: (context) {
                final chatRepository =
                    RepositoryProvider.of<ChatRepository>(context);

                return ChatBloc(chatRepository: chatRepository)
                  ..add(ChatLoadMessages());
              },
              child: ChatScreen(user: state.user),
            );
          } catch (e) {
            debugPrint('ChatBloc creation failed: $e');
            return const Scaffold(
              body: Center(child: Text('Failed to load chat: ChatBloc error')),
            );
          }
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
