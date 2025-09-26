import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../entities/task_priority.dart';
import '../repositories/task_repository.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Task> call(CreateTaskParams params) async {
    try {
      final task = Task(
        id: 0, // El ID será asignado por el servidor
        title: params.title,
        description: params.description,
        completed: false,
        createdAt: DateTime.now(),
        dueDate: params.dueDate,
        priority: TaskPriority.fromString(params.priority),
      );

      return await repository.createTask(task);
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}

class CreateTaskParams {
  final String title;
  final String description;
  final DateTime? dueDate;
  final String? priority;

  CreateTaskParams({
    required this.title,
    required this.description,
    this.dueDate,
    this.priority,
  });
}
