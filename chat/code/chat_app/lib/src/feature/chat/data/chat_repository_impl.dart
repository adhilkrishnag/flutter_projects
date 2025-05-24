import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../domain/message.dart';
import '../domain/chat_repository.dart';
import 'firebase_chat_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final FirebaseChatDataSource firebaseChatDataSource;

  ChatRepositoryImpl({required this.firebaseChatDataSource});

  @override
  Future<Either<Failure, void>> sendMessage(
      String content, String senderId) async {
    try {
      await firebaseChatDataSource.sendMessage(content, senderId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> getMessages() {
    try {
      return firebaseChatDataSource.getMessages().map((messages) {
        return Right<Failure, List<Message>>(messages.isEmpty ? [] : messages);
      }).handleError((error, stackTrace) {
        return Stream.value(Left<Failure, List<Message>>(ServerFailure(error.toString())));
      }, test: (error) => error is Exception);
    } catch (e) {
      return Stream.value(Left<Failure, List<Message>>(ServerFailure(e.toString())));
    }
  }
}