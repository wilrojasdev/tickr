import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final AuthRepository repository;

  Logout(this.repository);

  Future<void> call() async {
    try {
      await repository.logout();
    } catch (e) {
      if (e is CacheException) {
        throw CacheFailure(e.message);
      } else {
        throw CacheFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}
