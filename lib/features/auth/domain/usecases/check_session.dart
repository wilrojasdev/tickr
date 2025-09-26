import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckSession {
  final AuthRepository repository;

  CheckSession(this.repository);

  Future<User?> call() async {
    try {
      return await repository.checkSession();
    } catch (e) {
      if (e is CacheException) {
        throw CacheFailure(e.message);
      } else {
        throw CacheFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}
