part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatSendMessage extends ChatEvent {
  final String content;
  final String senderId;

  const ChatSendMessage(this.content, this.senderId);

  @override
  List<Object?> get props => [content, senderId];
}

class ChatLoadMessages extends ChatEvent {
  const ChatLoadMessages();
}

class ChatMessagesLoaded extends ChatEvent {
  final List<Message> messages;

  const ChatMessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatErrorOccurred extends ChatEvent {
  final String message;

  const ChatErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}