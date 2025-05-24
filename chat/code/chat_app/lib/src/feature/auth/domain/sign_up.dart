import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import 'user.dart';
import 'auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  SignUp(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.signUp(email, password);
  }
}