import '../../../../core/error/exceptions.dart';
import '../../../../core/network/fake_repository.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import 'dart:io';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await FakeRepository.post('/auth/login', {
        'username': username,
        'password': password,
      });

      final authResponse = AuthResponseModel.fromJson(response);

      if (authResponse.success) {
        return UserModel(
          id: authResponse.data.user.id,
          username: authResponse.data.user.username,
          token: authResponse.data.token,
        );
      } else {
        throw ServerException('Error en el login');
      }
    } on HttpException catch (e) {
      // Preservar el mensaje específico de HttpException
      throw ServerException(e.message);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException('Error inesperado: ${e.toString()}');
    }
  }
}
