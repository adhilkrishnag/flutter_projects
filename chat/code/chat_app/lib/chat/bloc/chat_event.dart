part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class ChatLoadMessages extends ChatEvent {}

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