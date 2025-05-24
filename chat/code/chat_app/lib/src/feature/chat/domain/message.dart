import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, senderId, content, timestamp];
}