import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/message.dart';
import '../domain/get_messages.dart';
import '../domain/send_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final GetMessages getMessages;

  ChatBloc({
    required this.sendMessage,
    required this.getMessages,
  }) : super(const ChatInitial()) {
    on<ChatSendMessage>(_onSendMessage);
    on<ChatLoadMessages>(_onLoadMessages);
    on<ChatMessagesLoaded>(_onMessagesLoaded);
    on<ChatErrorOccurred>(_onErrorOccurred);
  }

  Future<void> _onSendMessage(
      ChatSendMessage event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final result = await sendMessage(event.content, event.senderId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => emit(const ChatMessageSent()),
    );
  }

  void _onLoadMessages(ChatLoadMessages event, Emitter<ChatState> emit) {
    emit(const ChatLoading());
    getMessages().listen(
      (either) {
        either.fold(
          (failure) => add(ChatErrorOccurred(failure.message)),
          (messages) => add(ChatMessagesLoaded(messages)),
        );
      },
      onError: (error) {
        add(ChatErrorOccurred(error.toString()));
      },
    );
  }

  void _onMessagesLoaded(ChatMessagesLoaded event, Emitter<ChatState> emit) {
    emit(ChatLoaded(event.messages));
  }

  void _onErrorOccurred(ChatErrorOccurred event, Emitter<ChatState> emit) {
    emit(ChatError(event.message));
  }
}