import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import 'chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Either<Failure, void>> call(String content, String senderId) async {
    return await repository.sendMessage(content, senderId);
  }
}