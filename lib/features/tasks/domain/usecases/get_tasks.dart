import '../../../../core/error/failures.dart';
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<List<Task>> call() async {
    try {
      return await repository.getTasks();
    } catch (e) {
      if (e is ServerFailure) {
        rethrow;
      } else {
        throw ServerFailure('Error inesperado: ${e.toString()}');
      }
    }
  }
}
