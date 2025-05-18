part of 'chat_bloc.dart';

// Abstract base class for chat states
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

// Initial state before loading messages
class ChatInitial extends ChatState {}

// State when messages are loading
class ChatLoading extends ChatState {}

// State when messages are loaded
class ChatLoaded extends ChatState {
  final List<dynamic> messages; // Using dynamic to avoid QueryDocumentSnapshot dependency

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

// State when an error occurs
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}