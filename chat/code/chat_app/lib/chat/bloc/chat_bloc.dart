import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import '../chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<ChatLoadMessages>((event, emit) async {
      emit(ChatLoading());
      try {
        // Use stream to listen for real-time updates
        await emit.forEach(
          chatRepository.getMessagesStream(),
          onData: (messages) => ChatLoaded(messages),
          onError: (e, stackTrace) {
            debugPrint('Stream error: $e');
            return ChatError(e.toString());
          },
        );
      } catch (e) {
        debugPrint('Failed to load messages: $e');
        emit(ChatError(e.toString()));
      }
    });

    on<ChatSendMessage>((event, emit) async {
      try {
        await chatRepository.sendMessage(
          text: event.text,
          senderId: event.senderId,
          senderEmail: event.senderEmail,
        );
        // No need to reload messages; stream will update
      } catch (e) {
        debugPrint('Failed to send message: $e');
        emit(ChatError(e.toString()));
      }
    });
  }
}
