import '../../../../core/error/failures.dart';
import '../repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call(int taskId) async {
    try {
      await repository.deleteTask(taskId);
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}
