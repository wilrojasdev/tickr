import '../../../../core/error/exceptions.dart';
import '../../../../core/network/fake_repository.dart';
import '../models/task_model.dart';
import '../models/task_response_model.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(int taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final AuthLocalDataSource authLocalDataSource;

  TaskRemoteDataSourceImpl({
    required this.authLocalDataSource,
  });

  Future<Map<String, String>> _buildHeaders() async {
    try {
      final token = await authLocalDataSource.getCachedToken();
      if (token == null) {
        throw ServerException('Token de autenticación no encontrado');
      }

      return {
        'Authorization': 'Bearer $token',
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final headers = await _buildHeaders();
      final response = await FakeRepository.get('/tasks', headers: headers);

      final taskResponse = TaskResponseModel.fromJson(response);

      if (taskResponse.success) {
        final tasks = taskResponse.tasksList
            .map((taskData) => TaskModel.fromJson(taskData.toJson()))
            .toList();

        return tasks;
      } else {
        throw ServerException('Error al obtener las tareas');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException('Error inesperado: ${e.toString()}');
      }
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final headers = await _buildHeaders();
      final response =
          await FakeRepository.post('/tasks', task.toJson(), headers: headers);

      final taskResponse = TaskResponseModel.fromJson(response);

      if (taskResponse.success && taskResponse.singleTask != null) {
        return TaskModel.fromJson(taskResponse.singleTask!.toJson());
      } else {
        throw ServerException('Error al crear la tarea');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException('Error inesperado: ${e.toString()}');
      }
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final headers = await _buildHeaders();
      final response = await FakeRepository.put(
          '/tasks/${task.id}', task.toJson(),
          headers: headers);

      final taskResponse = TaskResponseModel.fromJson(response);

      if (taskResponse.success && taskResponse.singleTask != null) {
        final updatedTask =
            TaskModel.fromJson(taskResponse.singleTask!.toJson());
        return updatedTask;
      } else {
        throw ServerException('Error al actualizar la tarea');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException('Error inesperado: ${e.toString()}');
      }
    }
  }

  @override
  Future<void> deleteTask(int taskId) async {
    try {
      final headers = await _buildHeaders();
      final response =
          await FakeRepository.delete('/tasks/$taskId', headers: headers);

      final taskResponse = TaskResponseModel.fromJson(response);

      if (!taskResponse.success) {
        throw ServerException('Error al eliminar la tarea');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else {
        throw ServerException('Error inesperado: ${e.toString()}');
      }
    }
  }
}
