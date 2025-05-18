import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

// BLoC for managing chat logic
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    // Register event handlers
    on<ChatLoadMessages>(_onLoadMessages);
    on<ChatSendMessage>(_onSendMessage);
  }

  // Handle loading messages from Firestore
  void _onLoadMessages(ChatLoadMessages event, Emitter<ChatState> emit) {
    emit(ChatLoading());
    try {
      chatRepository.getMessages().listen((snapshot) {
        final messages = snapshot.docs;
        emit(ChatLoaded(messages));
      });
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  // Handle sending a new message
  Future<void> _onSendMessage(ChatSendMessage event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.sendMessage(
        event.text,
        event.senderId,
        event.senderEmail,
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}