import 'package:test/test.dart';
import 'package:tickr/core/error/exceptions.dart';
import 'package:tickr/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tickr/features/auth/data/models/user_model.dart';
import 'package:tickr/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:tickr/features/tasks/data/models/task_model.dart';
import 'package:tickr/features/tasks/domain/entities/task_priority.dart';

void main() {
  group('TaskRemoteDataSourceImpl', () {
    group('getTasks', () {
      test('éxito: retorna lista de tareas', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _ValidAuthLocalDataSource(),
        );

        final result = await dataSource.getTasks();

        expect(result, isA<List<TaskModel>>());
        expect(result.isNotEmpty, isTrue);
      });

      test('error: token inválido lanza ServerException', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _InvalidAuthLocalDataSource(),
        );

        expect(() => dataSource.getTasks(), throwsA(isA<ServerException>()));
      });
    });

    group('createTask', () {
      test('éxito: crea tarea', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _ValidAuthLocalDataSource(),
        );
        final testTask = TaskModel(
          id: 0,
          title: 'Test Task',
          description: 'Test Description',
          completed: false,
          createdAt: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 1)),
          priority: TaskPriority.medium,
        );

        final result = await dataSource.createTask(testTask);

        expect(result, isA<TaskModel>());
        expect(result.id, isNot(equals(0)));
        expect(result.title, equals('Test Task'));
      });

      test('error: token inválido lanza ServerException', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _InvalidAuthLocalDataSource(),
        );
        final testTask = TaskModel(
          id: 0,
          title: 'X',
          description: 'Y',
          completed: false,
          createdAt: DateTime.now(),
        );

        expect(() => dataSource.createTask(testTask),
            throwsA(isA<ServerException>()));
      });
    });

    group('updateTask', () {
      test('éxito: actualiza tarea', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _ValidAuthLocalDataSource(),
        );
        final testTask = TaskModel(
          id: 1,
          title: 'Updated Task',
          description: 'Updated Description',
          completed: true,
          createdAt: DateTime.now(),
          dueDate: DateTime.now(),
          priority: TaskPriority.high,
        );

        final result = await dataSource.updateTask(testTask);

        expect(result.id, equals(1));
        expect(result.title, equals('Updated Task'));
        expect(result.completed, isTrue);
      });

      test('error: token inválido lanza ServerException', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _InvalidAuthLocalDataSource(),
        );
        final testTask = TaskModel(
          id: 1,
          title: 'A',
          description: 'B',
          completed: false,
          createdAt: DateTime.now(),
        );

        expect(() => dataSource.updateTask(testTask),
            throwsA(isA<ServerException>()));
      });
    });

    group('deleteTask', () {
      test('éxito: elimina tarea', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _ValidAuthLocalDataSource(),
        );

        await dataSource.deleteTask(1);
        expect(true, isTrue);
      });

      test('error: token inválido lanza ServerException', () async {
        final dataSource = TaskRemoteDataSourceImpl(
          authLocalDataSource: _InvalidAuthLocalDataSource(),
        );

        expect(() => dataSource.deleteTask(1), throwsA(isA<ServerException>()));
      });
    });
  });
}

class _ValidAuthLocalDataSource implements AuthLocalDataSource {
  @override
  Future<void> cacheToken(String token) async {}

  @override
  Future<void> cacheUser(UserModel user) async {}

  @override
  Future<void> clearToken() async {}

  @override
  Future<void> clearUserCache() async {}

  @override
  Future<String?> getCachedToken() async => 'fake_token_123';

  @override
  Future<UserModel?> getCachedUser() async => null;
}

class _InvalidAuthLocalDataSource implements AuthLocalDataSource {
  @override
  Future<void> cacheToken(String token) async {}

  @override
  Future<void> cacheUser(UserModel user) async {}

  @override
  Future<void> clearToken() async {}

  @override
  Future<void> clearUserCache() async {}

  @override
  Future<String?> getCachedToken() async => 'invalid_token';

  @override
  Future<UserModel?> getCachedUser() async => null;
}
