import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../entities/task_priority.dart';
import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<Task> call(UpdateTaskParams params) async {
    try {
      final updatedTask = params.task.copyWith(
        title: params.title,
        description: params.description,
        completed: params.completed,
        dueDate: params.dueDate,
        priority: TaskPriority.fromString(params.priority),
      );

      return await repository.updateTask(updatedTask);
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}

class UpdateTaskParams {
  final Task task;
  final String? title;
  final String? description;
  final bool? completed;
  final DateTime? dueDate;
  final String? priority;

  UpdateTaskParams({
    required this.task,
    this.title,
    this.description,
    this.completed,
    this.dueDate,
    this.priority,
  });
}

// Extensión para agregar el método copyWith a Task
extension TaskCopyWith on Task {
  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskPriority? priority,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
    );
  }
}
