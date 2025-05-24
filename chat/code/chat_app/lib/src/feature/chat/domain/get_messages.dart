import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import 'message.dart';
import 'chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<Either<Failure, List<Message>>> call() {
    return repository.getMessages();
  }
}