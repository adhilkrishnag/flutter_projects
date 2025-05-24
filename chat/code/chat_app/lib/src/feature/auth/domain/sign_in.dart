import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import 'user.dart';
import 'auth_repository.dart';

class SignIn {
  final AuthRepository repository;

  SignIn(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}