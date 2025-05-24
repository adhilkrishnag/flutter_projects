import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import 'message.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> sendMessage(String content, String senderId);
  Stream<Either<Failure, List<Message>>> getMessages();
}