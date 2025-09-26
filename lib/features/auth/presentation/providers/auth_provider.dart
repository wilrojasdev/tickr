import 'package:flutter/material.dart';
import '../../../../core/services/notification_service.dart';
// removed unused failures import; errors are mapped via AuthErrorMapper
import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/check_session.dart';

class AuthProvider extends ChangeNotifier {
  final Login loginUseCase;
  final Logout logoutUseCase;
  final CheckSession checkSessionUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkSessionUseCase,
  });

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await loginUseCase(LoginParams(
        username: username,
        password: password,
      ));
      _setUser(user);
      NotificationService.showSuccess('¡Bienvenido, ${user.username}!');
    } catch (e) {
      final errorMessage = ErrorMapper.toUserMessage(e);
      _setError(errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _setError(null);

    try {
      await logoutUseCase();
      _setUser(null);
      NotificationService.showInfo('Sesión cerrada exitosamente');
    } catch (e) {
      final errorMessage = ErrorMapper.toUserMessage(e);
      _setError(errorMessage);
      NotificationService.showError('Error al cerrar sesión: $errorMessage');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkSession() async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await checkSessionUseCase();
      _setUser(user);
    } catch (e) {
      _setError(ErrorMapper.toUserMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }

  // Mensajería de error delegada a AuthErrorMapper (SRP)
}
