import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class Login {
  final AuthRepository repository;

  Login(this.repository);

  Future<User> call(LoginParams params) async {
    try {
      return await repository.login(params.username, params.password);
    } catch (e) {
      if (e is ServerException) {
        throw ServerFailure(e.message);
      } else if (e is CacheException) {
        throw CacheFailure(e.message);
      } else {
        throw ServerFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password,
  });
}
