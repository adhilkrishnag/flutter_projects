part of 'chat_bloc.dart';

// Abstract base class for chat events
abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

// Event to load messages
class ChatLoadMessages extends ChatEvent {}

// Event to send a message
class ChatSendMessage extends ChatEvent {
  final String text;
  final String senderId;
  final String senderEmail;

  const ChatSendMessage({
    required this.text,
    required this.senderId,
    required this.senderEmail,
  });

  @override
  List<Object> get props => [text, senderId, senderEmail];
}
