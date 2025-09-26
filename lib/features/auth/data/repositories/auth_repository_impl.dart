import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<User> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);

      await Future.wait([
        localDataSource.cacheUser(user),
        localDataSource.cacheToken(user.token),
      ]);

      return user.toEntity();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        localDataSource.clearUserCache(),
        localDataSource.clearToken(),
      ]);
    } catch (e) {
      throw CacheException('Error al cerrar sesión');
    }
  }

  @override
  Future<User?> checkSession() async {
    try {
      // Verificar tanto el usuario como el token por separado para mayor robustez
      final cachedUser = await localDataSource.getCachedUser();
      final cachedToken = await localDataSource.getCachedToken();

      if (cachedUser != null && cachedToken != null && cachedToken.isNotEmpty) {
        return cachedUser.toEntity();
      }

      return null;
    } catch (e) {
      throw CacheException('Error al verificar sesión');
    }
  }
}
